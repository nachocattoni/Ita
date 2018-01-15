#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "main.h"
#include "instruction-decoder.h"

/*
 * Returns the next line to be read.
 */
char *get_instruction_line(){
    char *line = (char *) malloc(MAX_BUFF_SIZE * sizeof(char));
    size_t sz = MAX_BUFF_SIZE;

    getline(&line, &sz, stdin);

    return line;
}

/*
 * Returns the next instruction to be executed,
 * as a list of words.
 */
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
    if(is_valid_variable_name(instr.words[0])){
        return ASSIGN;
    }
    return -1;
}
