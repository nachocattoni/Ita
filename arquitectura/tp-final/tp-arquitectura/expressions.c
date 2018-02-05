#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <limits.h>

#include "main.h"
#include "expressions.h"

bool is_valid_integer(const char *s){
    const int n = strlen(s);
    if(n >= 1 && n <= 11){
        int i;
        
        for(i = 1; i < n; i++){
            if(!isdigit(s[i])) return false;
        }
        if(!isdigit(s[0]) && s[0] != '-') return false;
        
        long long val = 0;
        bool neg = false;
        bool first_dig = true;
        bool first_dig_zero = false;
        for(i = 0; i < n; i++){
            if(s[i] == '-'){
                neg = true;
            }
            else {
                if(first_dig){
                    if(s[i] == '0'){
                        first_dig_zero = true;
                    }
                    first_dig = false;
                }
                val = val * 10;
                val = val + (s[i] - '0');
            }
        }
        if(neg) val = -val;
        
        if(first_dig_zero && !neg && n > 1) return false;
        if(first_dig_zero && neg) return false; /* No permito -0 */
        
        if(val < INT_MIN || val > INT_MAX) return false;
        
        return true;
    }
    return false;
}

bool is_valid_variable_name(const char *s){
    const int n = strlen(s);
    if(n >= 2 && n <= 11 && islower(s[0])){
        int i;

        for(i = 1; i < n; i++){
            if(!isdigit(s[i])) return false;
        }

        long long val = 0;
        for(i = 1; i < n; i++){
            val = val * 10;
            val = val + (s[i] - '0');
        }

        if(val > 2147483647) return false;

        return true;
    }
    return false;
}

operatorType get_operation_type(const char *word){
    const char *operators[] = OPERATOR_LIST;
    const operatorType operation_code[] = {SUMA, RESTA, MULTIPLICACION, 
        DIVISION, AND, OR, XOR, MENOR, MENOR_O_IGUAL, IGUAL, MAYOR, 
        MAYOR_O_IGUAL};
    int i;
    
    for(i = 0; i < NUMBER_OF_OPERATORS; i++){
        if(strcmp(word, operators[i]) == 0){
            return operation_code[i];
        }
    }
    
    return -1;
}

Expression get_next_expression(Instruction instr, int pos){
    Expression e; 
    int t;
    if(pos < instr.length){
        if(is_valid_variable_name(instr.words[pos])){
            e.valid = true;
            e.oper = NONE;
            
            Component v;
            v.code = instr.words[pos][0];
            v.value = atoi(instr.words[pos] + 1);
            
            e.v1 = v;
        }
        else if( (t = get_operation_type(instr.words[pos])) != -1){
            if(pos + 2 < instr.length){
                // Continue here...
            }
            else {
                e.valid = false;
            }
        }
        else {
            // Continue here...
        }
    }
    else {
        e.valid = false;
    }
    return e;
}

