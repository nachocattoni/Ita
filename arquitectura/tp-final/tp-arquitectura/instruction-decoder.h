/**
 * @file instruction-decoder.h
 * @brief Implementa funcionalidades para leer e interpretar 
 * instrucciones y expresiones.
 */

#ifndef INSTRUCTION_DECODER_H
#define INSTRUCTION_DECODER_H

#include "main.h"

/**
 * @brief Describe todos los tipos de instruccion posibles.
 */
typedef enum _instructionType {
    ASSIGN, /**< Asigna el valor de una expresion a una variable. */
    INPUT, /**< Lee un valor entero de stdin y lo escribe a una variable. */
    OUTPUT, /**< Escribe el valor de una expresion en la pantalla. */
    END, /**< Termina el programa. */
    JUMP, /**< Cambia el punto de ejecucion. */
    LABEL, /**< Declara una etiqueta, lugar al cual se puede cambiar el punto de ejecucion. */
    CONDITIONAL_JUMP, /**< Cambia condicionalmente el punto de ejecucion. */
    COMMENT, /**< No forma parte del código, es solo un comentario. */
    CALL, /**< Llama a una función. */
    FUNCTION, /**< Declara una función. */
    RETURN /**< Retorna a una función. */
} instructionType;

/**
 * @brief Una instruccion es un conjunto de palabras. 
 */
typedef struct _Instruction {
    int length;
    char **words;
} Instruction;

/**
 * Funcion auxiliar para obtener la siguiente linea de stdin.
 * @return La siguiente linea a leer de stdin.
 */
char *          get_instruction_line();

/**
 * @return La siguiente instruccion a leer, en forma de _Instruction.
 */
Instruction     get_next_instruction();

/**
 * Determina el tipo de instruccion que representa un objeto de tipo
 * _Instruction.
 * @param instr La instruccion de la cual se quiere averiguar el tipo.
 * @return El tipo de la instruccion, como un _instructionType.
 */
instructionType get_instruction_type(Instruction instr);

#endif // INSTRUCTION_DECODER_H
