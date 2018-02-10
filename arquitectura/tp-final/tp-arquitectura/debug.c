#include <stdio.h>
#include <string.h>

#include "expressions.h"
#include "storage.h"
#include "debug.h"

void show_component(Component c){
    if(!c.valid){
        fprintf(stderr, "Not a valid component:\n");
        return;
    }
    if(c.var == true){
        fprintf(stderr, "La componente corresponde a la variable %s\n", c.value);
    }
    else {
        fprintf(stderr, "La componente consiste del literal: %s\n", c.value);
    }
}

void show_expression(Expression e){
    if(!e.valid){
        fprintf(stderr, "No es una expresion valida\n");
    }
    else {
        if(e.oper != NONE){
            const char *operators[] = OPERATOR_LIST;
            fprintf(stderr, "La expresion consiste de dos componentes, siendo operadas por: %s\n", operators[e.oper]);
            fprintf(stderr, "Componente 1: "); show_component(e.v1);
            fprintf(stderr, "Componente 2: "); show_component(e.v2);
        }
        else {
            fprintf(stderr, "La expresion consiste de una sola componente\n");
            show_component(e.v1);
        }
    }
}

void show_bucket(Bucket *B){
    fprintf(stderr, "Showing Bucket (%d/%d):\n", B->nelems, B->sz);
    int i;
    for(i = 0; i < B->nelems; i++){
        fprintf(stderr, "%d: %s\n", i, B->storage[i]);
    }
}

void show_instruction(Instruction instr){
    int n = instr.length, i;
    fprintf(stderr, "La instruccion consiste de %d palabras.\n", n);
    for(i = 0; i < n; i++){
        fprintf(stderr, "sz(%d) -> %s\n", (int)strlen(instr.words[i]), instr.words[i]);
    }
}
