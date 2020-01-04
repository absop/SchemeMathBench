#!/usr/bin/scheme --script

(define fibonacci-iteration1
  (lambda (n)
    (define iterations
      (lambda (i)
        (let ([u (lambda (x y) (+ (* x x) (* y y)))]
              [v (lambda (x y) (* x (+ x (* 2 y))))])
          (if (logbit? i n)
              (values (lambda (x y) (u x (+ x y))) v)
              (values v u)))))
    (if (> n 1)
        (let loop ([x 0]
                   [y 1]
                   [i (1- (integer-length n))])
          (let-values (([iter0 iter1](iterations i)))
            (if (> i 0)
                (loop (iter0 x y)
                      (iter1 x y)
                      (1- i))
                (iter0 x y))))
        n)))

(define fibonacci-iteration2
  (lambda (n)
    (define (iterate x y i)
      (let ([x^2 (* x x)] [y^2 (* y y)]
            [g (if (logbit? i n) -2 2)]
            [j (- i 1)])
        (let ([y (+ (- (* y^2 4) x^2) g)])
          (if (<= j 0)
              (if (odd? n)
                  y
                  (- y (+ x^2 y^2)))
              (let ([x (+ x^2 y^2)])
                (if (logbit? j n)
                    (iterate (- y x) y j)
                    (iterate x (- y x) j)))))))
    (if (< n 2)
        n
        (iterate 0 1 (- (integer-length n) 1)))))

(define fibonacci-recursion
  (lambda (n)
    (if (> n 1)
        (let ([k (fxdiv n 2)])
          (let ([x (fibonacci-recursion (1- k))]
                [y (fibonacci-recursion k)])
            (if (odd? n)
                (let ([x (+ x y)])
                  (+ (* x x) (* y y)))
                (* y (+ y (* 2 x))))))
        n)))

(load "memoize.ss")

(function fibonacci-memoized1
          (lambda (n)
            (if (> n 1)
                (let ([k (fxdiv n 2)])
                  (let ([x (fibonacci-memoized1 (1- k))]
                        [y (fibonacci-memoized1 k)])
                    (if (odd? n)
                        (let ([x (+ x y)])
                          (+ (* x x) (* y y)))
                        (* y (+ y (* 2 x))))))
                n)))

(function fib2-memoized
          (lambda (n)
            (define square (lambda (x) (* x x)))
            (define return
              (lambda (xx yy g)
                (let ([xy (+ xx yy)]
                      [yx (+ (- (* yy 4) xx) g)])
                  (if (odd? n)
                      (cons (- yx xy) yx)
                      (cons xy (- yx xy))))))
            (if (< n 2)
                (cons 0 n)
                (let ([k (fxdiv n 2)])
                  (let ([fib2 (fib2-memoized k)])
                    (return (square (car fib2))
                            (square (cdr fib2))
                            (if (odd? k) -2 2))))
                )))

(define fibonacci-memoized2
  (lambda (n)
    (cdr (fib2-memoized n))))

;;; fibonacci-ordinay-loop
(define fibonacci-ordinay-loop
  (lambda (n)
    (let loop ([n n]
               [u 0]
               [v 1])
      (if (= n 0)
          u
          (loop (1- n) (+ u v) u)))))

;;; fibonacci-ordinay-tail-recursion
(define fibonacci-ordinay-tail-recursion
  (lambda (n)
    (define (help this next i)
      (if (= i 0)
          this
          (help next (+ this next) (- i 1))))
    (help 0 1 n)))


; #!eof
; (load "../../library/Scheme/ndigits.ss")

(define print-eval
  (lambda (symbol min max)
    (define f (eval symbol))
    (let loop ([i min])
      (when (<= i max)
            (printf "~a(~a) = ~a\n" symbol i (f i))
            (loop (1+ i))))
    (newline)))

(define test
  (lambda (funcnames maxn)
    (let ([functions (map eval funcnames)])
      (let loop ([i 0])
        (assert (apply = (map (lambda (f) (f i)) functions)))
        (if (<= i maxn)
            (loop (1+ i)))))))

(define bench
  (lambda (funcnames numbers)
    (let loop ([numbers numbers])
      (if (not (null? numbers))
          (let ([number (car numbers)])
            (let loop ([funcnames funcnames])
              (if (not (null? funcnames))
                  (let ([funcname (car funcnames)])
                    (printf "~s(~a)\n" funcname number)
                    (time ((eval funcname) number))
                    (printf "\n")
                    (loop (cdr funcnames)))))
            (loop (cdr numbers))))
      )))

(define fast-fibonacci-funcnames
  '(fibonacci-iteration1
    fibonacci-iteration2
    fibonacci-memoized1
    fibonacci-memoized2
    fibonacci-recursion))

(define ordinary-fibonacci-funcnames
  '(fibonacci-ordinay-loop
    fibonacci-ordinay-tail-recursion))


(test (append fast-fibonacci-funcnames
              ordinary-fibonacci-funcnames)
      1000)
(bench fast-fibonacci-funcnames '(1000000 1000001 1000000))


(time (fibonacci-ordinay-loop 100000))
(time (fibonacci-ordinay-tail-recursion 100000))
