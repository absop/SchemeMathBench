(eval-when (compile) (optimize-level 3))

(load "factorial1.ss")
(load "factorial2.ss")
(load "factorial3.ss")
(load "simple-factorial.ss")

(load "../../library/Scheme/ndigits.ss")


(define (benchmark times limit number)
  (define check
    (let ([criterion-method 'factorial-recursion]
          [criterion-values '()])
      (lambda (method values)
        (let ([i (caar values)]
              [n (cdar values)])
          (printf "~a: digits: ~a, " method (ndigits n 10)))
        (if (eq? method criterion-method)
            (let ()
              (set! criterion-values values)
              (printf "pass.\n"))
            (let ([fails '()])
              (for-each
                (lambda (value criterion-value)
                  (if (not (equal? value criterion-value))
                      (set! fails (cons value fails))))
                values
                criterion-values)
              (if (null? fails)
                  (printf "pass.\n")
                  (printf "fail at ~a\n" (map car fails))))))))

  (define repeat
    (let ([numbers (cons number (iota (+ limit 1)))])
      (define (get-values method)
        (map (lambda (i) (cons i (method i))) numbers))
      (lambda (method)
        (lambda ()
          (let ([values '()])
            (for-each
              (lambda (i) (set! values (get-values method)))
              (iota times))
            values)))))

  (define-syntax bench
    (syntax-rules ()
      [(_ method)
       (begin
         (collect)
         (let ([method (repeat method)])
           (check 'method (time (method))))
         (newline))]))

  (printf "bench with times: ~a, numbers: (~a, [0-~a])\n" times number limit)
  (bench factorial-recursion)
  (bench factorial-YC)
  (bench factorial-loop1)
  (bench factorial-loop2)
  (bench factorial-tail-recursion1)
  (bench factorial-tail-recursion2)
  (bench factorial!)
  (bench factorial1)
  (bench factorial2)
  (bench factorial3)
  )


(benchmark 1 1000 20000)


#!eof
bench with times: 1, numbers: (100000, [0-1000])
(time (factorial-recursion))
    204 collections
    10.859375000s elapsed cpu time, including 0.015625000s collecting
    10.955747800s elapsed real time, including 0.052531700s collecting
    9238438240 bytes allocated, including 9206345408 bytes reclaimed
factorial-recursion: digits: 456574, pass.

(time (factorial-YC))
    209 collections
    10.796875000s elapsed cpu time, including 0.062500000s collecting
    10.803582000s elapsed real time, including 0.064763800s collecting
    9278209824 bytes allocated, including 9198528416 bytes reclaimed
factorial-YC: digits: 456574, pass.

(time (factorial-loop1))
    299 collections
    8.484375000s elapsed cpu time, including 0.046875000s collecting
    8.585185600s elapsed real time, including 0.063727900s collecting
    10191092416 bytes allocated, including 10164849968 bytes reclaimed
factorial-loop1: digits: 456574, pass.

(time (factorial-loop2))
    145 collections
    3.671875000s elapsed cpu time, including 0.015625000s collecting
    3.670473600s elapsed real time, including 0.027659000s collecting
    4771366256 bytes allocated, including 4715599296 bytes reclaimed
factorial-loop2: digits: 456574, pass.

(time (factorial-tail-recursion1))
    299 collections
    7.781250000s elapsed cpu time, including 0.015625000s collecting
    7.862263800s elapsed real time, including 0.049593800s collecting
    10191092416 bytes allocated, including 10163603040 bytes reclaimed
factorial-tail-recursion1: digits: 456574, pass.

(time (factorial-tail-recursion2))
    145 collections
    4.796875000s elapsed cpu time, including 0.031250000s collecting
    4.882149200s elapsed real time, including 0.046829500s collecting
    4771366256 bytes allocated, including 4715599296 bytes reclaimed
factorial-tail-recursion2: digits: 456574, pass.

(time (factorial!))
    1 collection
    1.968750000s elapsed cpu time, including 0.015625000s collecting
    1.991799200s elapsed real time, including 0.000360400s collecting
    13573184 bytes allocated, including 8289008 bytes reclaimed
factorial!: digits: 456574, pass.

(time (factorial1))
    9 collections
    1.734375000s elapsed cpu time, including 0.000000000s collecting
    1.745398300s elapsed real time, including 0.001476200s collecting
    109445184 bytes allocated, including 104357456 bytes reclaimed
factorial1: digits: 456574, pass.

(time (factorial2))
    1 collection
    1.500000000s elapsed cpu time, including 0.000000000s collecting
    1.523287200s elapsed real time, including 0.000569800s collecting
    10513936 bytes allocated, including 7819840 bytes reclaimed
factorial2: digits: 456574, pass.

(time (factorial3))
    1 collection
    1.609375000s elapsed cpu time, including 0.000000000s collecting
    1.648122400s elapsed real time, including 0.000640200s collecting
    11229072 bytes allocated, including 7757680 bytes reclaimed
factorial3: digits: 456574, pass.

[Finished in 54.1s]
