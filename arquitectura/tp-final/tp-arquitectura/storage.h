#ifndef STORAGE_H
#define STORAGE_H

#include "main.h"

typedef struct _Bucket {
    int sz, nelems;
    char **storage;
} Bucket;

Bucket create_new_bucket();

void insert_element(Bucket *B, const char *v);

#endif // STORAGE_H
