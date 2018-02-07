#include <stdlib.h>
#include <string.h>

#include "main.h"
#include "storage.h"

Bucket create_new_bucket(){
    Bucket B;
    
    B.nelems = 0;
    B.sz = 4;
    B.storage = (char **) malloc(MAX_BUFF_SIZE * sizeof(char *));
    
    return B;
}

int insert_element(Bucket *B, const char *v){
    int i;
    for(i = 0; i < B->nelems; i++){
        if(strcmp(B->storage[i], v) == 0){
            return i;
        }
    }
    if(B->nelems >= B->sz){
        B->storage = (char **) realloc(B->storage, (B->sz * 2) * sizeof(char *));
        B->sz *= 2;
    }
    B->storage[B->nelems] = (char *) malloc(MAX_VARIABLE_NAME_SIZE * sizeof(char));
    strcpy(B->storage[B->nelems], v);
    B->nelems++;
    return B->nelems - 1;
}
