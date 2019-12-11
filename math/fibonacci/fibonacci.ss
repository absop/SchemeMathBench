#!/usr/bin/scheme --script

(define fibonacci
  (lambda (n)
    (define iterations
      (lambda (i)
        (let ([u (lambda (x y) (+ (* x x) (* y y)))]
              [v (lambda (x y) (* x (+ x (* 2 y))))])
          (if (logbit? i n)
              (values (lambda (x y) (u x (+ x y)))
                      v)
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


(define fibonacci-recursion
  (lambda (n)
    (if (> n 1)
        (let ([u (fibonacci-recursion (1- (fxdiv n 2)))]
              [v (fibonacci-recursion (fxdiv n 2))])
          (if (odd? n)
              (let ([u (+ u v)]) (+ (* u u) (* v v)))
              (* v (+ v (* 2 u)))))
        n)))


;;; fibonacci-ordinay
(define fibonacci-ordinay
  (lambda (n)
    (let loop ([n n]
               [u 0]
               [v 1])
      (if (= n 0)
          u
          (loop (1- n) (+ u v) u)))))


(define print-eval
  (lambda (function min max)
    (let loop ([n min])
      (if (<= n max)
          (let ([val ((eval function) n)])
            (printf "~a(~a) = ~a\n" function n val)
            (loop (1+ n)))
          (newline)))))

(define function-equal?
  (lambda (f1 f2 n)
    (let loop ([i 1])
      (if (= (f1 i) (f2 i))
          (if (< i n) (loop (1+ i)) #t)
          i))))

(load "../library/ndigits.ss")

; (print-eval 'fibonacci 0 100)
; (print-eval 'fibonacci-recursion 0 100)
; (print-eval 'fibonacci-ordinay 0 100)

(printf "~a\n"
        (function-equal? fibonacci fibonacci-recursion 100))
(printf "~a\n"
        (function-equal? fibonacci fibonacci-ordinay 100))

(time (set! fib0 (fibonacci 1000000)))
(time (set! fib1 (fibonacci-recursion 1000000)))
; (time (set! fib2 (fibonacci-ordinay 1000000)))

(printf "~a\n" (integer-length fib0))
(printf "~a\n" (integer-length fib1))

(printf "~a\n" (ndigits fib0))
(printf "~a\n" (ndigits fib1))
; (printf "~a\n" (integer-length fib2))
