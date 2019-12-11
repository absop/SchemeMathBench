(load "../../../library/Scheme/for.ss")
(load "bitvector.ss")


(define eratosthenes
  (lambda (maxn)
    (let ([mask (make-bitvector (1+ maxn) 1)]
          [primes (list 2)]
          [sqr (isqrt maxn)])
      (define tail primes)
      (for i in range(3 maxn 2):
           (when (bitvector-ref mask i)
                 (set-cdr! tail (list i))
                 (set! tail (cdr tail))
                 ; (set! primes (cons i primes))
                 (if (<= i sqr)
                     (for j = ((* i i) maxn (+ i i)):
                          (bitvector-reset! mask j)))))
      ; (reverse! primes)
      primes)))

(define euler
  (lambda (maxn)
    (let ([mask (make-bitvector (1+ maxn) 1)]
          [primes (list 2)])
      (define tail primes)
      (for i = (3 maxn 2):
           (when (bitvector-ref mask i)
                 (set-cdr! tail (list i))
                 (set! tail (cdr tail)))
           (let loop ([head (cdr primes)])
             (if (not (null? head))
                 (let ([index (* i (car head))])
                   (when (<= index maxn)
                         ; (printf "~a\n" index)
                         (bitvector-reset! mask index)
                         (if (not (= (remainder i (car head)) 0))
                             (loop (cdr head))))))))
      primes)))

(define get-primes
  (case-lambda
    [(n) (eratosthenes n)]
    [(n method)
     (case method
       [eratosthenes (eratosthenes n)]
       [euler (euler n)])]))


(define benchmark
  (lambda (n method)
    (printf "~a sieving:\n" method)
    (time (set! primes (get-primes n method)))
    (time (set! number (length primes)))
    (printf "~a primes\n" number)))


(printf "~a\n" (get-primes 100))
(printf "~a\n" (get-primes 100 'euler))

(benchmark 100000000 'eratosthenes)
(benchmark 100000000 'euler)

#!eof
(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)
(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)
(time (set! primes ...))
    11 collections
    1.953125000s elapsed cpu time, including 0.234375000s collecting
    1.966224800s elapsed real time, including 0.226511400s collecting
    192190416 bytes allocated, including 516096 bytes reclaimed
(time (set! number ...))
    no collections
    0.015625000s elapsed cpu time
    0.012362700s elapsed real time
    0 bytes allocated
5761455
(time (set! primes ...))
    11 collections
    2.046875000s elapsed cpu time, including 0.312500000s collecting
    2.042748200s elapsed real time, including 0.305687800s collecting
    192190352 bytes allocated, including 100041936 bytes reclaimed
(time (set! number ...))
    no collections
    0.015625000s elapsed cpu time
    0.013300300s elapsed real time
    0 bytes allocated
5761455
[Finished in 4.3s]
