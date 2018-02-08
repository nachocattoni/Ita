#include <stdio.h>

#include "expressions.h"
#include "storage.h"
#include "debug.h"

void show_component(Component c){
    if(!c.valid){
        printf("Not a valid component:\n");
        return;
    }
    if(c.var == true){
        printf("La componente corresponde a la variable %s\n", c.value);
    }
    else {
        printf("La componente consiste del literal: %s\n", c.value);
    }
}

void show_expression(Expression e){
    if(!e.valid){
        printf("No es una expresion valida\n");
    }
    else {
        if(e.oper != NONE){
            const char *operators[] = OPERATOR_LIST;
            printf("La expresion consiste de dos componentes, siendo operadas por: %s\n", operators[e.oper]);
            printf("Componente 1: "); show_component(e.v1);
            printf("Componente 2: "); show_component(e.v2);
        }
        else {
            printf("La expresion consiste de una sola componente\n");
            show_component(e.v1);
        }
    }
}

void show_bucket(Bucket *B){
    printf("Showing Bucket (%d/%d):\n", B->nelems, B->sz);
    int i;
    for(i = 0; i < B->nelems; i++){
        printf("%d: %s\n", i, B->storage[i]);
    }
}
