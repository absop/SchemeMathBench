(load "vector-mul.ss")
(load "../../library/Scheme/bitvector.ss")

(define make-primes
  (lambda (maxn)
    (define (exponents index)
      (let sum ([dividend maxn][expo 0])
        (if (< dividend index)
            expo
            (let ([dividend (fxdiv dividend index)])
              (sum dividend (+ expo dividend))))))
    (define half (fxdiv maxn 2))
    (define sqrm (isqrt maxn))
    (define v (make-bitvector (1+ maxn) 1))
    (define mprimels (list (expt 2 (exponents 2))))
    (define sprimels '())
    (define index 3)
    (let loop ()
      (when (<= index half)
          (when (bitvector-ref v index)
                (set! mprimels
                      (cons (expt index (exponents index)) mprimels))
                (if (<= index sqrm)
                    (let ([dealta (+ index  index)])
                      (let sieve ([index (* index index)])
                        (when (<= index maxn)
                              (bitvector-reset! v index)
                              (sieve (+ index dealta)))))))
          (set! index (+ index 2))
          (loop)))

    (let loop ()
      (when (<= index maxn)
          (if (bitvector-ref v index)
              (set! sprimels (cons index sprimels)))
          (set! index (+ index 2))
          (loop)))
    (cons sprimels mprimels)))


(define factorial1
  (lambda (n)
    (let ([primes (make-primes n)])
      (let ([v (list->vector (car primes))])
        (* (vector-mul v (vector-length v))
           (apply * (cdr primes)))))))


(define factorial!
  (lambda (n)
    (let ([primes (make-primes n)])
      (let ([sing (list->vector (car primes))]
            [many (list->vector (cdr primes))])
        (* (vector-mul sing (vector-length sing))
           (vector-mul many (vector-length many)))))))
