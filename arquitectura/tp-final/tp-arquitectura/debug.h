#ifndef DEBUG_H
#define DEBUG_H

#include "storage.h"
#include "expressions.h"

/**
 * Dada una componente, imprime por pantalla toda la informacion sobre
 * ella.
 */
void show_component(Component c);

/**
 * Dada una expresion, imprime por pantalla toda la informacion sobre
 * ella.
 */
void show_expression(Expression e);

/**
 * Dado un bucket, muestra la capacidad de este, y muestra cada 
 * elemento al lado de su índice en el bucket.
 */
void show_bucket(Bucket *B);

/**
 * Dada una instruccion, muestra la cantidad de palabras de esta,
 * y cada elemento en una nueva linea.
 */
void show_instruction(Instruction instr);

#endif // DEBUG_H
