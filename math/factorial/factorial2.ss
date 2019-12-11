(load "vector-mul.ss")
(load "../../library/Scheme/bitvector.ss")

(define factorial2
  (lambda (maxn)
    (define (count-exponent prime)
      (let loop ([temp maxn] [count 0])
        (if (< temp prime)
            count
            (let ([temp (fxdiv temp prime)])
              (loop temp (+ count temp))))))
    (define sieve-primes
      (lambda (start dealta)
        (let loop ([j start])
          (when (<= j maxn)
                (bitvector-reset! isprime j)
                (loop (+ j dealta))))))

    (define sqrm (isqrt maxn))
    (define half (fxdiv maxn 2))
    (define small-pair '())
    (define middle-pair '())
    (define large-prime '())
    (define isprime (make-bitvector (1+ maxn) 1))
    (define i 3)

    (let loop ()
      (when (<= i sqrm)
            (if (bitvector-ref isprime i)
                (let ([pair (cons i (count-exponent i))])
                  (set! small-pair (cons pair small-pair))
                  (sieve-primes (* i i) (+ i i))))
            (set! i (+ i 2))
            (loop)))

    (let loop ()
      (when (<= i half)
            (if (bitvector-ref isprime i)
                (let ([pair (cons i (count-exponent i))])
                  (set! middle-pair (cons pair middle-pair))))
            (set! i (+ i 2))
            (loop)))

    (let loop ()
      (when (<= i maxn)
            (if (bitvector-ref isprime i)
                (set! large-prime (cons i large-prime)))
            (set! i (+ i 2))
            (loop)))

    (let ([small-part (vector-pow-mul (list->vector small-pair))]
          [middle-part (vector-pow-mul (list->vector middle-pair))]
          [large-part (vector-mul (list->vector large-prime))])
      (let ([result (* middle-part (* small-part large-part))])
        (ash result (count-exponent 2))))))


; (for-each
;   (lambda (i) (printf "~a\n" (factorial2 i)))
;   '(1 2 3 4 5 6 7 8 9 10))
