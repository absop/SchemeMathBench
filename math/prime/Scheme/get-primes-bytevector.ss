(load "../../../library/Scheme/for.ss")

(define eratosthenes
  (lambda (maxn)
    (let ([mask (make-bytevector (1+ maxn) 1)]
          [primes (list 2)]
          [sqr (isqrt maxn)])
      (define tail primes)
      (for i in range(3 maxn 2):
           (when (= 1 (bytevector-u8-ref mask i))
                 (set-cdr! tail (list i))
                 (set! tail (cdr tail))
                 ; (set! primes (cons i primes))
                 (if (<= i sqr)
                     (for j = ((* i i) maxn (+ i i)):
                          (bytevector-u8-set! mask j 0)))))
      ; (reverse! primes)
      primes)))

(define euler
  (lambda (maxn)
    (let ([mask (make-bytevector (1+ maxn) 1)]
          [primes (list 2)])
      (define tail primes)
      (for i = (3 maxn 2):
           (if (= 1 (bytevector-u8-ref mask i))
               (begin
                 (set-cdr! tail (list i))
                 (set! tail (cdr tail))
                 (let loop ([head (cdr primes)])
                   (if (not (null? head))
                       (let ([index (* i (car head))])
                         (when (<= index maxn)
                               ; (printf "~a\n" index)
                               (bytevector-u8-set! mask index 0)
                               (loop (cdr head)))))))
               (let loop ([head (cdr primes)])
                 (if (not (null? head))
                     (let ([index (* i (car head))])
                       (when (<= index maxn)
                             ; (printf "~a\n" index)
                             (bytevector-u8-set! mask index 0)
                             (if (not (= (remainder i (car head)) 0))
                                 (loop (cdr head)))))))))
      primes)))


(define (benchmark times limit)
  (define (bench siever)
    (let ([result '()])
      (for-each
        (lambda (i) (set! result (siever limit)))
        (iota times))
      result))

  (define-syntax bench-siever
    (syntax-rules ()
      [(_ siever)
       (begin (collect)
              (display (length (time (bench siever))))
              (newline))]))

  (printf "bench with times: ~a, limit: ~a\n" times limit)
  (bench-siever eratosthenes)
  (bench-siever euler))


(benchmark 10 100000000)


#!eof
bench with times: 10, limit: 10000000
(time (bench eratosthenes))
    12 collections
    2.625000000s elapsed cpu time, including 0.312500000s collecting
    2.694848400s elapsed real time, including 0.278120700s collecting
    206341488 bytes allocated, including 176508448 bytes reclaimed
664579
(time (bench euler))
    13 collections
    1.968750000s elapsed cpu time, including 0.218750000s collecting
    1.951958600s elapsed real time, including 0.221721000s collecting
    206341488 bytes allocated, including 143190560 bytes reclaimed
664579
[Finished in 4.9s]

bench with times: 10, limit: 100000000
(time (bench eratosthenes))
    110 collections
    32.453125000s elapsed cpu time, including 6.000000000s collecting
    33.297318100s elapsed real time, including 6.014299900s collecting
    1921904368 bytes allocated, including 1170237440 bytes reclaimed
5761455
(time (bench euler))
    110 collections
    27.500000000s elapsed cpu time, including 5.531250000s collecting
    27.666042300s elapsed real time, including 5.716858000s collecting
    1921903728 bytes allocated, including 2014103984 bytes reclaimed
5761455
[Finished in 61.3s]
