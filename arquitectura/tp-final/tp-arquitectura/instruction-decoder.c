#include <stdio.h>
#include <stdlib.h>

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

    instr.word = (char **) malloc(MAX_BUFF_SIZE * sizeof(char *));
    instr.length = 0;
    const char* skip = " \t\n";

    char *s = strtok(line, skip);
    while(s != NULL){
        instr.word[instr.length] = (char *) malloc(MAX_BUFF_SIZE * sizeof(char));
        strcpy(instr.word[instr.length], s);
        instr.length++;
        s = strtok(NULL, skip);
    }

    return instr;
}
