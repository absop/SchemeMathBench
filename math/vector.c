#include <stdlib.h>
#include <memory.h>
#include "vector.h"

#define MAKE_VECTOR_NEW(bit)                                        \
int##bit##_vector_t *int##bit##_vector_new(size_t length)           \
{                                                                   \
    int##bit##_vector_t *v = malloc(sizeof (int##bit##_vector_t));  \
    v->length = (size_t)0;                                          \
    v->alloced = length;                                            \
    v->data = malloc(length * sizeof(int##bit##_t));                \
    return v;                                                       \
}

#define MAKE_VECTOR_APPEND(bit)                                         \
void int##bit##_vector_append(int##bit##_vector_t *v, int##bit##_t x)   \
{                                                                       \
    if (v->length >= v->alloced) {                                      \
        v->alloced += VECTOR_GROW_SIZE;                                 \
        v->data = realloc(v->data, v->alloced * sizeof x);              \
    }                                                                   \
    v->data[v->length++] = x;                                           \
}

#define MAKE_VECTOR_RESIZE(bit)                                         \
void int##bit##_vector_resize(int##bit##_vector_t *v, size_t length)    \
{                                                                       \
    v->data = realloc(v->data, length * sizeof(int##bit##_t));          \
    v->alloced = length;                                                \
    if (length < v->length)                                             \
        v->length = length;                                             \
}

#define MAKE_VECTOR_FREE(bit)                        \
void int##bit##_vector_free(int##bit##_vector_t *v)  \
{                                                    \
    free(v->data);                                   \
    v->length = (size_t)0;                           \
    v->alloced = (size_t)0;                          \
    free(v);                                         \
}

MAKE_VECTOR_NEW(32)
MAKE_VECTOR_NEW(64)
MAKE_VECTOR_APPEND(32)
MAKE_VECTOR_APPEND(64)
MAKE_VECTOR_RESIZE(32)
MAKE_VECTOR_RESIZE(64)
MAKE_VECTOR_FREE(32)
MAKE_VECTOR_FREE(64)
size_t int32_vector_length(int32_vector_t* v) { return v->length; }
size_t int64_vector_length(int64_vector_t* v) { return v->length; }

// static __inline int32_cmp(const void *a, const void *b)
// {
//     return *((int32_t *)a) - *((int32_t *)b);
// }
// static __inline int64_cmp(const void *a, const void *b)
// {
//     return *((int64_t *)a) - *((int64_t *)b);
// }

// void vector_quick_sort(vector_t *v)
// {
//     qsort(v->data, v->length, 4, int32_cmp);
// }

// void vector_merge_sort(vector_t *v)
// {}

// void vector_shell_sort(vector_t *v)
// {}
