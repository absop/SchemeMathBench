(load-shared-object "get-primes-int32-vector.so")


(define-ftype int32-vector
  (struct
    [usable integer-64]
    [length integer-64]
    [data (* integer-32)]))


(define eratosthenes
  (foreign-procedure "eratosthenes" (int) (* int32-vector)))
(define euler
  (foreign-procedure "euler" (int) (* int32-vector)))
(define count
  (foreign-procedure "int32_vector_length" ((* int32-vector)) integer-64))
(define free
  (foreign-procedure "int32_vector_free" ((* int32-vector)) void))


(define (vector i32v)
  (let* ([l (count i32v)]
         [v (make-vector l)])
    (let loop ([i 0])
      (when (< i l)
            (vector-set! v i (ftype-ref int32-vector (data i) i32v))
            (loop (1+ i))))
    (free i32v)
    v))
