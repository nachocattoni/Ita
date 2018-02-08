#ifndef WRITER_H
#define WRITER_H

#include "expressions.h"
#include "storage.h"

/**
 * Evalua una componente, dejando su valor guardado en el registro
 * indicado por el parámetro where. 
 * @param v Componente que se quiere evaluar.
 * @param B Bucket que contiene los nombres de las variables, y al
 * cual se van a agregar nombres de variables.
 * @param where Indica en qué registro se guarda el valor del 
 * componente.
 */
void evaluate_component(Component v, Bucket *B, int where);

/**
 * Evalua una expresion, dejando su valor guardado en r1, para uso
 * posterior via printf/scanf.
 * @param e La expresion que se quiere evaluar.
 * @param B Bucket que contiene los nombres de las variables
 * ya utilizadas, y al que potencialmente se va a agregar nombres
 * de variables en la expresion.
 */
void evaluate_expression(Expression e, Bucket *B);

#endif // WRITTER_H
