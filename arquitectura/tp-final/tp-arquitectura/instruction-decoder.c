#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "main.h"
#include "instruction-decoder.h"

char *get_instruction_line(){
    char *line = (char *) malloc(MAX_BUFF_SIZE * sizeof(char));
    size_t sz = MAX_BUFF_SIZE;

    getline(&line, &sz, stdin);

    return line;
}

Instruction get_next_instruction(){
    Instruction instr;
    char *line = get_instruction_line();

    instr.words = (char **) malloc(MAX_BUFF_SIZE * sizeof(char *));
    instr.length = 0;
    const char* skip = " \t\n";

    char *s = strtok(line, skip);
    while(s != NULL){
        instr.words[instr.length] = (char *) 
            malloc(MAX_BUFF_SIZE * sizeof(char));
        strcpy(instr.words[instr.length], s);
        instr.length++;
        s = strtok(NULL, skip);
    }

    return instr;
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

instructionType get_instruction_type(Instruction instr){
    const char *s = instr.words[0];
    if(is_valid_variable_name(s)){
        return ASSIGN;
    }
    
    const char *instructionTypes[] = {"R", "O", "E", "G", "L", "I"};
    const instructionType types[] = {INPUT, OUTPUT, END, JUMP, LABEL, 
        CONDITIONAL_JUMP};
    int i;
    
    for(i = 0; i < NUMBER_OF_INSTRUCTION_TYPES; i++){
        if(strcmp(s, instructionTypes[i]) == 0){
            return types[i];
        }
    }
    return -1;
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
    if(pos < instr.length){
		if(is_valid_variable_name(instr.words[pos])){
			e.valid = true;
			e.oper = NONE;
			
			Component v;
			v.code = instr.words[pos][0];
			v.value = atoi(instr.words[pos] + 1);
			
			e.v1 = v;
		}
		else if(get_operation_type(instr.words[pos]) != -1){
			
		}
		else {
			printf("Nothing here...\n");
		}
	}
	else {
		e.valid = false;
	}
    return e;
}

void show_component(Component c){
	if(c.code == '?'){
		printf("La componente consiste del literal: %d\n", c.value);
	}
	else {
		printf("La componente corresponde a la variable %c%d\n", c.code,
			c.value);
	}
}

void show_expression(Expression e){
	if(!e.valid){
		printf("No es una expresion valida\n");
	}
	else {
		if(e.oper != NONE){
			const char *operators[] = OPERATOR_LIST;
			printf("La expresion consiste de dos componentes, siendo operadas por: %s\n", operators[e.oper]);
			printf("Componente 1: "); show_component(e.v1);
			printf("Componente 2: "); show_component(e.v2);
		}
		else {
			printf("La expresion consiste de una sola componente\n");
			show_component(e.v1);
		}
	}
}
