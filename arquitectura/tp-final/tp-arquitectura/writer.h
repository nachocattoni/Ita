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

/**
 * Imprime el valor alojado en r1 por pantalla. Asume que la instruccion
 * push {ip, lr} fue usada al comienzo, y que pop {ip, pc} será usada
 * al final.
 */
void print_value();

/**
 * Lee un valor de la entrada estándar y lo almacena en la posición
 * correspondiente del arreglo universe.
 * @param B Bucket con los nombres de las variables.
 * @param s Nombre de la variable en la cual guardar el valor leido.
 */
void scan_value(Bucket *B, const char *s);

/**
 * Carga el valor de r1 en la variable defnida por la cadena pasada.
 * @param B Bucket con los nombres de las variables.
 * @param s Nombre de la variable, se supone que es válido.
 */
void load_value(Bucket *B, const char *s);

/**
 * Marca un label en el programa, correspondiente al número de etiqueta
 * que recibe como parámetro.
 * @param l Número de etiqueta que representa al label. 
 */
void mark_label(const char *l);

/**
 * Salta al label en el programa, correspondiente al número de etiqueta
 * que recibe como parámetro.
 * @param l Número de etiqueta que representa al label. 
 */
void jump_label(const char *l);

/**
 * Escribe un salto condicional, en el caso de que el valor en r1
 * sea distinto de 0.
 * @param l Numero de la etiqueta a la cual saltar.
 */
void conditional_jump(const char *l);

/**
 * Escribe la instrucción de abandonar el programa.
 */
void exit_program();

/**
 * Escribe todo el código necesario para inicializar el programa en 
 * ARM. 
 */
void initialize();

/**
 * Escribe todo el código necesario al final de programa ARM.
 */
void terminate(Bucket *B);

#endif // WRITTER_H
