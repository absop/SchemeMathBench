(eval-when (compile) (optimize-level 3))


(define-syntax benchmark
  (syntax-rules ()
    [(_ times limit prefix)
     (let ()
       (load (format "get-primes-~a.ss" 'prefix))
       (let ()
         (define (bench siever)
           (let ([result '()])
             (for-each
               (lambda (i) (set! result (siever limit)))
               (iota times))
             result))

         (define-syntax bench-siever
           (lambda (x)
             (define (join-name prefix suffix)
               (datum->syntax prefix
                 (string->symbol
                   (format "~a:~a"
                     (syntax->datum prefix)
                     (syntax->datum suffix)))))
             (syntax-case x ()
               [(_ siever)
                (with-syntax ([alias (join-name #'prefix #'siever)])
                  #'(let ([alias siever])
                      (collect)
                      (let ([primes (time (bench alias))])
                        (display (count primes))
                        (newline)
                        (free primes))))])))

         (printf "bench with times: ~a, limit: ~a\n" times limit)
         (bench-siever eratosthenes)
         (bench-siever euler)))]))


(benchmark 10 100000000 linked-list)
(benchmark 10 100000000 int32-vector)

#!eof
bench with times: 10, limit: 10000000
(time (bench linked-list:eratosthenes))
    no collections
    0.843750000s elapsed cpu time
    0.830860200s elapsed real time
    368 bytes allocated
664579
(time (bench linked-list:euler))
    no collections
    1.000000000s elapsed cpu time
    1.019607600s elapsed real time
    368 bytes allocated
664579
bench with times: 10, limit: 10000000
(time (bench int32-vector:eratosthenes))
    no collections
    0.343750000s elapsed cpu time
    0.344785400s elapsed real time
    368 bytes allocated
664579
(time (bench int32-vector:euler))
    no collections
    0.593750000s elapsed cpu time
    0.605894400s elapsed real time
    368 bytes allocated
664579
[Finished in 3.2s]

bench with times: 1, limit: 100000000
(time (bench linked-list:eratosthenes))
    no collections
    1.234375000s elapsed cpu time
    1.273648800s elapsed real time
    80 bytes allocated
5761455
(time (bench linked-list:euler))
    no collections
    1.000000000s elapsed cpu time
    1.018657800s elapsed real time
    80 bytes allocated
5761455
bench with times: 1, limit: 100000000
(time (bench int32-vector:eratosthenes))
    no collections
    0.796875000s elapsed cpu time
    0.811919400s elapsed real time
    80 bytes allocated
5761455
(time (bench int32-vector:euler))
    no collections
    0.687500000s elapsed cpu time
    0.695423000s elapsed real time
    80 bytes allocated
5761455
[Finished in 4.9s]

bench with times: 10, limit: 100000000
(time (bench linked-list:eratosthenes))
    no collections
    13.109375000s elapsed cpu time
    13.555321200s elapsed real time
    368 bytes allocated
5761455
(time (bench linked-list:euler))
    no collections
    12.250000000s elapsed cpu time
    12.413642000s elapsed real time
    368 bytes allocated
5761455
bench with times: 10, limit: 100000000
(time (bench int32-vector:eratosthenes))
    no collections
    7.765625000s elapsed cpu time
    7.834347600s elapsed real time
    368 bytes allocated
5761455
(time (bench int32-vector:euler))
    no collections
    7.750000000s elapsed cpu time
    7.818697100s elapsed real time
    368 bytes allocated
5761455
[Finished in 42.8s]
