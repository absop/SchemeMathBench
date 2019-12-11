#ifndef _VECTOR_H
#define _VECTOR_H

#include <stdint.h>

typedef struct _int32_vector {
    size_t alloced;
    size_t length;
    int32_t *data;
} int32_vector_t;


typedef struct _int64_vector {
    size_t alloced;
    size_t length;
    int64_t *data;
} int64_vector_t;

#define VECTOR_GROW_SIZE 32


int32_vector_t *int32_vector_new(size_t length);
int64_vector_t *int64_vector_new(size_t length);

size_t int32_vector_length(int32_vector_t* v);
size_t int64_vector_length(int64_vector_t* v);

void int32_vector_append(int32_vector_t* v, int32_t x);
void int32_vector_resize(int32_vector_t *v, size_t length);
void int32_vector_free(int32_vector_t *v);

void int64_vector_append(int64_vector_t* v, int64_t x);
void int64_vector_resize(int64_vector_t *v, size_t length);
void int64_vector_free(int64_vector_t *v);

#endif /* _VECTOR_H */
