(eval-when (compile) (optimize-level 3))

(define-ftype linked-list
              (struct
                [this integer-64]
                [next (* linked-list)]))

(define-ftype int32-vector
              (struct
                [alloced integer-64]
                [_length integer-64]
                [data (* integer-32)]))


(define get-primes
  (let* ([env (make-hash-table)]
         [put (lambda (key value) (put-hash-table! env key value))]
         [get (lambda (key) (get-hash-table env key 'undefined))]
         [get-primes
          (lambda (algorithm ds n)
            (let ([f (get (string->symbol (format "~a-~a" ds algorithm)))]
                  [t (get (string->symbol (format "~a->~a" ds 'vector)))])
              (t (f n))))])
    (load-shared-object "get-primes-linked-list.so")
    (put 'linked-list-eratosthenes
         (foreign-procedure "eratosthenes" (int) (* linked-list)))
    (put 'linked-list-euler
         (foreign-procedure "euler" (int) (* linked-list)))
    (put 'linked-list-length
         (foreign-procedure "list_length" ((* linked-list)) integer-64))
    (put 'linked-list-free!
         (foreign-procedure "list_free" ((* linked-list)) void))

    (load-shared-object "get-primes-int32-vector.so")
    (put 'int32-vector-eratosthenes
         (foreign-procedure "eratosthenes" (int) (* int32-vector)))
    (put 'int32-vector-euler
         (foreign-procedure "euler" (int) (* int32-vector)))
    (put 'int32-vector-length
         (foreign-procedure "int32_vector_length" ((* int32-vector)) integer-64))
    (put 'int32-vector-free!
         (foreign-procedure "int32_vector_free" ((* int32-vector)) void))

    (put 'linked-list->vector
         (lambda (ll)
           (define v (make-vector ((get 'linked-list-length) ll)))
           (let loop ([head ll][i 0])
             (when (not (= (ftype-pointer-address head) 0))
                   (vector-set! v i (ftype-ref linked-list (this) head))
                   (loop (ftype-ref linked-list (next) head)
                         (1+ i))))
           ((get 'linked-list-free!) ll)
           v))
    (put 'int32-vector->vector
         (lambda (i32v)
           (define l ((get 'int32-vector-length) i32v))
           (define v (make-vector l))
           (let loop ([i 0])
             (when (< i l)
                   (vector-set! v i (ftype-ref int32-vector (data i) i32v))
                   (loop (1+ i))))
           ((get 'int32-vector-free!) i32v)
           v))

    (case-lambda
      [(n) (get-primes 'eratosthenes 'int32-vector n)]
      [(n algorithm) (get-primes algorithm 'int32-vector n)]
      [(n algorithm ds) (get-primes algorithm ds n)])))


(define MAXN)
(define benchmark
  (lambda (algorithm ds)
    (time (set! p100 (get-primes 100 algorithm ds)))
    (time (set! primes (get-primes MAXN algorithm ds)))
    (printf "~a-~a:\n" ds algorithm)
    (printf "\t~a\n" p100)
    (printf "\t~a\n" (vector-length primes))))


(set! MAXN 100000000)
(benchmark 'euler 'linked-list)
(benchmark 'euler 'int32-vector)
(benchmark 'eratosthenes 'linked-list)
(benchmark 'eratosthenes 'int32-vector)

; (compile-file "get-primes.ss")
