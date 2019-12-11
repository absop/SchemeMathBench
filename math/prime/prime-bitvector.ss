(load "../../library/bitvector.ss")
; (load "bitvector.ss")

(define get-primes
  (lambda (maxn)
    (let ([mask (make-bitvector (1+ maxn) 1)]
          [primes (list 2)]
          [sqr (isqrt maxn)])
      (define tail primes)
      (let loop ([i 3])
        (when (<= i maxn)
              (when (bitvector-ref mask i)
                    (set-cdr! tail (list i))
                    (set! tail (cdr tail))
                    (if (<= i sqr)
                        (let ([j (* i i)][delta (+ i i)])
                          (let sieve ([j j])
                            (when (<= j maxn)
                                  (bitvector-reset! mask j)
                                  (sieve (+ j delta)))))))
              (loop (+ i 2))))
      ; (bitvector-free! mask)
      primes)))



(define benchmark
  (lambda (n)
    (time (set! primes (get-primes n)))
    (time (set! number (length primes)))
    (printf "~a\n" number)))

(printf "~a\n" (get-primes 100))
(benchmark 100000000)
