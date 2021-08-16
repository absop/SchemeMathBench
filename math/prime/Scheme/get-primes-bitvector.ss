(eval-when (compile) (optimize-level 3))


(define (path-join dir name)
  (cond
    [(or (string=? dir "") (string=? dir ".")) name]
    [(directory-separator?
       (string-ref dir (fx- (string-length dir) 1)))
     (format "~a~a" dir name)]
    [(format "~a/~a" dir name)]))

(define (find-library path)
  (cond
    [(file-exists? path) path]
    [(path-absolute? path) #f]
    [(let loop ([ldirs (library-directories)])
       (if (not (null? ldirs))
           (let ([path (path-join (caar ldirs) path)])
             (or (and (file-exists? path) path)
                 (loop (cdr ldirs))))
           #f))]
    [else #f]))

(define (load-relatively path)
  (cond
    [(find-library path) =>
     (lambda (path)
       (let ([origin-dir (cd)]
             [target-dir (path-parent path)]
             [target-name (path-last path)])
         (cd target-dir)
         (load (path-join (cd) target-name))
         (cd origin-dir)))]
    [(error 'load-relatively
       "failed for ~a: no such file or directory" path)]))


(define (make-siever library)
  (load-relatively library)
  (let ()
    (define (eratosthenes maxn)
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
                          (let ([j (* i i)] [delta (+ i i)])
                            (let sieve ([j j])
                              (when (<= j maxn)
                                    (bitvector-reset! mask j)
                                    (sieve (+ j delta)))))))
                (loop (+ i 2))))
        (if (top-level-bound? 'free-bitvector)
            (free-bitvector mask))
        primes))

    (define (euler maxn)
      (let ([mask (make-bitvector (1+ maxn) 1)]
            [primes (list 2)])
        (define tail primes)
        (let loop ([i 3])
          (when (<= i maxn)
                (if (bitvector-ref mask i)
                    (begin
                      (set-cdr! tail (list i))
                      (set! tail (cdr tail))
                      (let loop ([head (cdr primes)])
                        (if (not (null? head))
                            (let ([index (* i (car head))])
                              (when (<= index maxn)
                                    ; (printf "~a/n" index)
                                    (bitvector-reset! mask index)
                                    (loop (cdr head)))))))
                    (let loop ([head (cdr primes)])
                      (if (not (null? head))
                          (let ([index (* i (car head))])
                            (when (<= index maxn)
                                  ; (printf "~a/n" index)
                                  (bitvector-reset! mask index)
                                  (if (not (= (remainder i (car head)) 0))
                                      (loop (cdr head))))))))
                (loop (+ i 2))))
        (if (top-level-bound? 'free-bitvector)
            (free-bitvector mask))
        primes))

    (values eratosthenes euler)))


(library-directories '("../../../library" "."))

(define-values (scheme-eratosthenes scheme-euler)
  (make-siever "Scheme/bitvector.ss"))

(define-values (c-eratosthenes c-euler)
  (make-siever "C/bitvector.ss"))


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
  (bench-siever c-eratosthenes)
  (bench-siever c-euler)
  (bench-siever scheme-eratosthenes)
  (bench-siever scheme-euler))

(benchmark 10 100000000)


#!eof
bench with times: 10, limit: 10000000
(time (bench c-eratosthenes))
    12 collections
    2.078125000s elapsed cpu time, including 0.156250000s collecting
    2.101684100s elapsed real time, including 0.130855300s collecting
    106341840 bytes allocated, including 42663456 bytes reclaimed
664579
(time (bench c-euler))
    12 collections
    2.203125000s elapsed cpu time, including 0.093750000s collecting
    2.202208300s elapsed real time, including 0.090506500s collecting
    106341008 bytes allocated, including 63807600 bytes reclaimed
664579
(time (bench scheme-eratosthenes))
    12 collections
    2.250000000s elapsed cpu time, including 0.078125000s collecting
    2.275188100s elapsed real time, including 0.102630800s collecting
    106341648 bytes allocated, including 95708544 bytes reclaimed
664579
(time (bench scheme-euler))
    12 collections
    2.296875000s elapsed cpu time, including 0.140625000s collecting
    2.354614800s elapsed real time, including 0.128667500s collecting
    106341008 bytes allocated, including 106341216 bytes reclaimed
664579
[Finished in 9.3s]

bench with times: 10, limit: 100000000
(time (bench c-eratosthenes))
    110 collections
    30.812500000s elapsed cpu time, including 2.890625000s collecting
    31.245592100s elapsed real time, including 2.970064100s collecting
    921904720 bytes allocated, including 368945696 bytes reclaimed
5761455
(time (bench c-euler))
    110 collections
    31.031250000s elapsed cpu time, including 2.796875000s collecting
    31.435284700s elapsed real time, including 2.848287000s collecting
    921903888 bytes allocated, including 1014087632 bytes reclaimed
5761455
(time (bench scheme-eratosthenes))
    110 collections
    33.093750000s elapsed cpu time, including 2.875000000s collecting
    33.332547400s elapsed real time, including 3.046290900s collecting
    921904528 bytes allocated, including 1106272384 bytes reclaimed
5761455
(time (bench scheme-euler))
    110 collections
    31.125000000s elapsed cpu time, including 2.312500000s collecting
    31.318874000s elapsed real time, including 2.487205700s collecting
    921903888 bytes allocated, including 460986304 bytes reclaimed
5761455
[Finished in 128.0s]
