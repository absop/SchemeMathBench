
(define-syntax function
  (lambda (x)
    (syntax-case x ()
      [(_ name procedure)
       #'(define name
          (let ([cache (make-hashtable equal-hash equal?)])
            (lambda args
              (if (hashtable-contains? cache args)
                  (hashtable-ref cache args #f)
                  (let ([result (apply procedure args)])
                    (hashtable-set! cache args result)
                    result)
                  ))
            ))])))


#!eof
(eval-when (compile) (optimize-level 3))

(define fib
  (lambda (n)
    (if (< n 2)
        n
        (+ (fib (- n 1))
           (fib (- n 2))))))

(function mfib
         (lambda (n)
           (if (< n 2)
               n
               (+ (mfib (- n 1))
                  (mfib (- n 2))))))


(time (fib 40))
(time (mfib 40))
(time (mfib 40))
