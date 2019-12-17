
(define memoize
  (lambda (f)
    (let ([table (make-hash-table)])
      (lambda (n)
        (let ([result (get-hash-table table n #f)])
          (or result
              (let ([result (f n)])
                (put-hash-table! table n result)
                result))
          ))
      )))

(define-syntax mdef
  (lambda (f)
    (syntax-case f ()
      [(_ f expr)
       #'(define f (memoize expr))])))


#!eof
(eval-when (compile) (optimize-level 3))

(define fib
  (lambda (n)
    (if (< n 2)
        n
        (+ (fib (- n 1))
           (fib (- n 2))))))

(mdef mfib
  (lambda (n)
    (if (< n 2)
        n
        (+ (mfib (- n 1))
           (mfib (- n 2))))))


(time (fib 40))
(time (mfib 40))
