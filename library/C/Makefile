

data-structures = bitvector.so linked-list.so vector.so


object: $(data-structures)


bitvector.so: bitvector.c
	gcc -O2 -fPIC -shared -o bitvector.so bitvector.c

linked-list.so: linked-list.c
	gcc -O2 -fPIC -shared -o linked-list.so linked-list.c

vector.so: vector.c vector.h
	gcc -O2 -fPIC -shared -o vector.so vector.c



.PHONY:

clean:
			rm -f $(data-structures)
