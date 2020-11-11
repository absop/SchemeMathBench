(load "../../../library/Scheme/bitvector.ss")
(load "../../../library/Scheme/for.ss")

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
           (if (bitvector-ref mask i)
               (begin
                 (set-cdr! tail (list i))
                 (set! tail (cdr tail))
                 (let loop ([head (cdr primes)])
                   (if (not (null? head))
                       (let ([index (* i (car head))])
                         (when (<= index maxn)
                               ; (printf "~a\n" index)
                               (bitvector-reset! mask index)
                               (loop (cdr head)))))))
               (let loop ([head (cdr primes)])
                 (if (not (null? head))
                     (let ([index (* i (car head))])
                       (when (<= index maxn)
                             ; (printf "~a\n" index)
                             (bitvector-reset! mask index)
                             (if (not (= (remainder i (car head)) 0))
                                 (loop (cdr head)))))))))
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
eratosthenes sieving:
(time (set! primes ...))
    11 collections
    2.281250000s elapsed cpu time, including 0.171875000s collecting
    2.296354600s elapsed real time, including 0.172763100s collecting
    104690416 bytes allocated, including 2455632 bytes reclaimed
(time (set! number ...))
    no collections
    0.015625000s elapsed cpu time
    0.013932000s elapsed real time
    0 bytes allocated
5761455 primes
euler sieving:
(time (set! primes ...))
    11 collections
    2.093750000s elapsed cpu time, including 0.234375000s collecting
    2.107569600s elapsed real time, including 0.251261200s collecting
    104690352 bytes allocated, including 12542528 bytes reclaimed
(time (set! number ...))
    no collections
    0.015625000s elapsed cpu time
    0.016055600s elapsed real time
    0 bytes allocated
5761455 primes
[Finished in 4.7s]
