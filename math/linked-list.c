#include <stdlib.h>
#include <stdint.h>

#define append(tail, x) tail->next = list_new(x, NULL)

typedef struct _list {
    int64_t this;
    struct _list *next;
} list_t;

list_t *list_new(int this, list_t *next)
{
    list_t *l = malloc(sizeof (list_t));
    l->this = this;
    l->next = next;
    return l;
}

size_t list_length(list_t *l)
{
    size_t length = 0;
    for (; l; l = l->next)
        ++length;
    return length;
}

void list_free(list_t *list)
{
    for (list_t *p; list; ) {
        p = list->next;
        free(list);
        list = p;
    }
}
