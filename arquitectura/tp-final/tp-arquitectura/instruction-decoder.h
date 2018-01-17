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
    CONDITIONAL_JUMP /**< Cambia condicionalmente el punto de ejecucion. */
} instructionType;

/**
 * @brief Una instruccion es un conjunto de palabras. 
 */
typedef struct _Instruction {
    int length;
    char **words;
} Instruction;


/**
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

/**
 * @param s El nombre de la cadena.
 * @return Retorna verdadero si la cadena corresponde a un nombre valido
 * para una variable: una letra seguida de un numero de etiqueta, donde
 * un numero de etiqueta es un valor entre 0 y 2147483647. No se 
 * permiten ceros a izquierda.
 */
bool            is_valid_variable_name(const char *s);

/**
 * Lee una expresion de una lista de palabras. Recordar que una
 * expresion es: un literal, una variable, o un operador seguido de dos
 * literales o variables.
 * @param words Un puntero a la primer palabra de una lista de palabras.
 * @return Retorna verdadero en caso de que la expresion se haya leido
 * con exito.
 */
bool 			get_next_expression(const char** words);

#endif // INSTRUCTION_DECODER_H
