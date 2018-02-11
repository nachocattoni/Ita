/**
 * @file storage.h
 * @brief Implementa Bucket, la estructura de datos para guardar
 * los nombres de las variables y asignarles un número.
 */
 
#ifndef STORAGE_H
#define STORAGE_H

#include "main.h"

/**
 * @brief Una estructura dedicada a mantener un conjunto de nombres
 * de variables, y asociar cada una a un entero.
 */
typedef struct _Bucket {
    int sz, nelems;
    char **storage;
} Bucket;

/**
 * @return Retorna un nuevo _Bucket.
 */
Bucket create_new_bucket();

/**
 * @param B El bucket al cual se le quiere agregar el elemento.
 * @param v La cadena de texto que se quiere meter en el _Bucket.
 * Introduce el elemento en el bucket, si es que no existe todavía.
 * @return Si el elemento ya existe en el bucket, retorna la posición
 * en la que se encuentra. De otra manera, lo inserta al final, y 
 * retorna esta posición.
 */
int insert_element(Bucket *B, const char *v);

#endif // STORAGE_H
