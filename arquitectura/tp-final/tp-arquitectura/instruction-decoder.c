#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "instruction-decoder.h"
#include "expressions.h"

char *get_instruction_line(){
    char *line = (char *) malloc(MAX_BUFF_SIZE * sizeof(char));
    size_t sz = MAX_BUFF_SIZE;

    getline(&line, &sz, stdin);

    return line;
}

Instruction get_next_instruction(){
    Instruction instr;
    char *line = get_instruction_line();
    
    if((int)strlen(line) == 0){
        instr.words = NULL;
        instr.length = 0;
        return instr;
    }

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
