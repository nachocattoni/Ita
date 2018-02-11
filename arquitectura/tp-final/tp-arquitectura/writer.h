/**
 * @file writer.h
 * @brief Consta de todas las funciones para imprimir el programa
 * en ARM por pantalla.
 */
#ifndef WRITER_H
#define WRITER_H

#include "expressions.h"
#include "storage.h"

/**
 * Escribe la evaluación de una componente, dejando su valor guardado 
 * en el registro indicado por el parámetro where.
 * @param v Componente que se quiere evaluar.
 * @param B Bucket que contiene los nombres de las variables, y al
 * cual se van a agregar nombres de variables.
 * @param where Indica en qué registro se guarda el valor del 
 * componente.
 */
void evaluate_component(Component v, Bucket *B, int where);

/**
 * Escribe la evaluación una expresion, dejando su valor guardado en 
 * r1, para uso posterior, posiblemente via printf.
 * @param e La expresion que se quiere evaluar.
 * @param B Bucket que contiene los nombres de las variables
 * ya utilizadas, y al que potencialmente se va a agregar nombres
 * de variables en la expresion.
 */
void evaluate_expression(Expression e, Bucket *B);

/**
 * Escribe la impresión del valor alojado en r1 por pantalla. Asume 
 * que la instruccion push {ip, lr} fue usada al comienzo, y que 
 * pop {ip, pc} será usada al final.
 */
void print_value();

/**
 * Escribe la lectura de un valor de la entrada estándar y su 
 * almacenamiento en la posición correspondiente del arreglo universe.
 * @param B Bucket con los nombres de las variables.
 * @param s Nombre de la variable en la cual guardar el valor leido.
 */
void scan_value(Bucket *B, const char *s);

/**
 * Escribe la carga del valor de r1 en la variable definida por la 
 * cadena pasada.
 * @param B Bucket con los nombres de las variables.
 * @param s Nombre de la variable, se supone que es válido.
 */
void load_value(Bucket *B, const char *s);

/**
 * Escribe una etiqueta en el programa, correspondiente al número de 
 * etiqueta que recibe como parámetro.
 * @param l Número de etiqueta. 
 */
void mark_label(const char *l);

/**
 * Escribe un salto a una etiqueta en el programa, correspondiente 
 * al número de etiqueta que recibe como parámetro.
 * @param l Número de etiqueta. 
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
 * Escribe el llamado a una funcion en ARM.
 * @param name Nombre de la funcion a llamar.
 */
void write_call(const char *name);

/**
 * Escribe la declaracion de una funcion en ARM.
 * @param name Nombre de la función a declarar.
 */
void declare_function(const char *name);

/**
 * Escribe el retorno de una función en ARM.
 * @param name Nombre de la función de la cual retornar.
 */
void return_function(const char *name);

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
