#ifndef INSTRUCTION_DECODER_H
#define INSTRUCTION_DECODER_H

#include "main.h"

typedef enum _instructionType {
    ASSIGN,
    INPUT,
    OUTPUT,
    END,
    JUMP,
    LABEL,
    CONDITIONAL_JUMP
} instructionType;

typedef struct _Instruction {
    int length;
    char **words;
} Instruction;

char *          get_instruction_line();
Instruction     get_next_instruction();
instructionType get_instruction_type(Instruction);
bool            is_valid_variable_name(const char *);

#endif // INSTRUCTION_DECODER_H
