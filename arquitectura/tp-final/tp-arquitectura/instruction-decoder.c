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
        instr.words[instr.length] = (char *) malloc(MAX_BUFF_SIZE * sizeof(char));
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
    if(strcmp(s, "R") == 0){
		return INPUT;
	}
	if(strcmp(s, "O") == 0){
		return OUTPUT;
	}
	if(strcmp(s, "E") == 0){
		return END;
	}
	if(strcmp(s, "G") == 0){
		return JUMP;
	}
	if(strcmp(s, "L") == 0){
		return LABEL;
	}
	if(strcmp(s, "I") == 0){
		return CONDITIONAL_JUMP;
	}
    return -1;
}
