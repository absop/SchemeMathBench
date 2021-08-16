(load-shared-object "get-primes-linked-list.so")


(define-ftype linked-list
  (struct
    [this integer-64]
    [next (* linked-list)]))


(define eratosthenes
  (foreign-procedure "eratosthenes" (int) (* linked-list)))
(define euler
  (foreign-procedure "euler" (int) (* linked-list)))
(define count
  (foreign-procedure "list_length" ((* linked-list)) integer-64))
(define free
  (foreign-procedure "list_free" ((* linked-list)) void))


(define (vector ll)
  (let ([v (make-vector (count ll))])
    (let loop ([head ll] [i 0])
      (when (not (= (ftype-pointer-address head) 0))
            (vector-set! v i (ftype-ref linked-list (this) head))
            (loop (ftype-ref linked-list (next) head) (1+ i))))
    (free ll)
    v))
