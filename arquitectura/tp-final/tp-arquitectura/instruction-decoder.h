#ifndef INSTRUCTION_DECODER_H
#define INSTRUCTION_DECODER_H

typedef enum _codeType {
    ASSIGN,
    INPUT,
    OUTPUT,
    END,
    JUMP,
    LABEL,
    CONDITIONAL_JUMP
} codeType;

typedef struct _Instruction {
    int length;
    char **word;
} Instruction;

char *      get_instruction_line();
Instruction get_next_instruction();

#endif // INSTRUCTION_DECODER_H
