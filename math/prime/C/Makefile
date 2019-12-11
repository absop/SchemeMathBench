

get-primes = get-primes-int32-vector.so get-primes-linked-list.so


shared-object: $(get-primes)

get-primes-int32-vector.so: get-primes-int32-vector.c
	gcc -O3 -fPIC -shared -o get-primes-int32-vector.so get-primes-int32-vector.c

get-primes-linked-list.so: get-primes-linked-list.c
	gcc -O3 -fPIC -shared -o get-primes-linked-list.so get-primes-linked-list.c



.PHONY:

clean:
		rm -f $(get-primes)
