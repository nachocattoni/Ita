/**
 * @file instruction-decoder.h
 * @brief Defines the types of instructions and provides functionalities
 * to read and decode the meaning of each line.
 */

#ifndef INSTRUCTION_DECODER_H
#define INSTRUCTION_DECODER_H

#include "main.h"

/**
 * @brief All possible types of instruction.
 */
typedef enum _instructionType {
    ASSIGN, /**< This type of instruction assigns the value of an expression to a variable. */
    INPUT, /**< This type of instruction reads an integer value from stdin to a variable. */
    OUTPUT, /**< This type of instruction writes to screen the value of an expression. */
    END, /**< This type of instruction ends the program. */
    JUMP, /**< This type of instruction changes the point of execution. */
    LABEL, /**< This type of instruction declares a checkpoint for instructions. */
    CONDITIONAL_JUMP /**< This type of instruction conditionally changes the point of execution. */
} instructionType;

/**
 * @brief An instruction is a set of words, and its corresponding length. 
 */
typedef struct _Instruction {
    int length;
    char **words;
} Instruction;


/**
 * Reads a new line and returns it.
 */
char *          get_instruction_line();

/**
 * Reads a new line, decomposes it into single instructions (words),
 * and returns them as an Instruction.
 */
Instruction     get_next_instruction();

/**
 * Receives an instruction and returns the type of it.
 * @param instr The instruction of which you want to know the type.
 * @return Returns the type of the instruction.
 */
instructionType get_instruction_type(Instruction instr);

/**
 * @param s The name of the string
 * @return Returns true if the string is a valid variable name.
 */
bool            is_valid_variable_name(const char *s);

#endif // INSTRUCTION_DECODER_H
