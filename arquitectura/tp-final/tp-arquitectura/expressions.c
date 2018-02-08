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

bool is_label_number(const char *s){
    return isdigit(s[0]) && is_valid_integer(s);
}

bool is_valid_variable_name(const char *s){
    const int n = strlen(s);
    return n >= 2 && islower(s[0]) && is_label_number(s + 1);
}

operatorType get_operator_type(const char *word){
    const char *operators[] = OPERATOR_LIST;
    const operatorType operator_code[] = {SUMA, RESTA, MULTIPLICACION, 
        DIVISION, AND, OR, XOR, MENOR, MENOR_O_IGUAL, IGUAL, MAYOR, 
        MAYOR_O_IGUAL};
    int i;
    
    for(i = 0; i < NUMBER_OF_OPERATORS; i++){
        if(strcmp(word, operators[i]) == 0){
            return operator_code[i];
        }
    }
    
    return NONE;
}

Component get_component(const char *s){
    Component ans;
    bool variable = is_valid_variable_name(s);
    bool literal = is_valid_integer(s);
    ans.valid = variable || literal;
    ans.var = variable;
    ans.value = malloc(MAX_VARIABLE_NAME_SIZE * sizeof(char));
    strcpy(ans.value, s);
    return ans;
}

Expression get_next_expression(Instruction instr, int pos){
    Expression e;
    operatorType t;
    if(pos < instr.length){
        if(is_valid_integer(instr.words[pos]) || is_valid_variable_name(instr.words[pos])){
            e.valid = true;
            e.oper = NONE;
            Component v;
            v = get_component(instr.words[pos]);
            e.v1 = v;
        }
        else if( (t = get_operator_type(instr.words[pos])) != NONE ){
            if(pos + 2 < instr.length){
                /* En pos se encuentra el operador */
                /* En pos + 1 se encuentra el primer operando */
                /* En pos + 2 se encuentra el segundo operando */
                Component l, r;
                l = get_component(instr.words[pos + 1]);
                r = get_component(instr.words[pos + 2]);
                if(l.valid && r.valid){
                    e.valid = true;
                    e.oper = t;
                    e.v1 = l;
                    e.v2 = r;
                }
                else e.valid = false;
            }
            else {
                e.valid = false;
            }
        }
        else {
            e.valid = false;
        }
    }
    else {
        e.valid = false;
    }
    return e;
}

