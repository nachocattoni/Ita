#ifndef EXPRESSIONS_H
#define EXPRESSIONS_H

#include "main.h"
#include "instruction-decoder.h"

/**
 * @brief Representa un literal o una variable. Si es un literal, code
 * vale '?'. De lo contrario, si es, por ejemplo, la variable p278, 
 * entonces code vale 'p', y value es 278. 
 * Si no es válido, code vale '#'.
 */
typedef struct _Component {
    char code;
    int value;
} Component;

/**
 * @brief Describe los tipos de operaciones posibles. 
 */
typedef enum _operatorType {
    SUMA,
    RESTA, 
    MULTIPLICACION,
    DIVISION,
    AND,
    OR,
    XOR,
    MENOR,
    MENOR_O_IGUAL,
    IGUAL,
    MAYOR,
    MAYOR_O_IGUAL,
    NONE
} operatorType;

/**
 * @brief Representa una expresion. Una expresion es un componente
 * unico, o es una operacion seguido de dos componentes. Si oper es
 * NONE, entonces el valor de la expresion esta solo en el componente v1.
 */
typedef struct _Expression {
    bool valid;
    operatorType oper;
    Component v1, v2;
} Expression;

bool            is_valid_integer(const char *s);

/**
 * @param s El nombre de la cadena.
 * @return Retorna verdadero si la cadena corresponde a un nombre valido
 * para una variable: una letra seguida de un numero de etiqueta, donde
 * un numero de etiqueta es un valor entre 0 y 2147483647. No se 
 * permiten ceros a izquierda.
 */
bool            is_valid_variable_name(const char *s);

/**
 * Funcion auxiliar usada para determinar que operador simboliza una 
 * palabra dada, en caso de que lo haga. Un operador es uno de la 
 * siguiente lista: +, -, *, /, &, *, |, ^, <, <=, ==, >, >=.
 * @param word La palabra que posiblemente represente el operador.
 * @return El operador que representa la palabra o -1 si no.
 */
operatorType    get_operation_type(const char *word);

/**
 * Lee una expresion de una lista de palabras. Recordar que una
 * expresion es: un literal, una variable, o un operador seguido de dos
 * literales o variables.
 * @param instr Es la instruccion de la cual leer la expresion.
 * @param pos Es la posicion desde la cual leer la instruccion.
 * @return Retorna la expresion, en caso de fallo retorna una expresion
 * no valida.
 */
Expression      get_next_expression(Instruction instr, int pos);


#endif // EXPRESSIONS_H
