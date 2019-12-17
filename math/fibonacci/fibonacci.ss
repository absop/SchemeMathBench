#!/usr/bin/scheme --script

(define fibonacci
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


(define fibonacci-recursion
  (lambda (n)
    (if (> n 1)
        (let ([u (fibonacci-recursion (1- (fxdiv n 2)))]
              [v (fibonacci-recursion (fxdiv n 2))])
          (if (odd? n)
              (let ([u (+ u v)]) (+ (* u u) (* v v)))
              (* v (+ v (* 2 u)))))
        n)))

(load "memoize.ss")

(mdef fibonacci-memoized
      (lambda (n)
        (if (> n 1)
            (let ([u (fibonacci-memoized (1- (fxdiv n 2)))]
                  [v (fibonacci-memoized (fxdiv n 2))])
              (if (odd? n)
                  (let ([u (+ u v)]) (+ (* u u) (* v v)))
                  (* v (+ v (* 2 u)))))
            n)))

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
(load "../../library/Scheme/ndigits.ss")

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


; (print-eval 'fibonacci 0 100)
; (print-eval 'fibonacci-recursion 0 100)
; (print-eval 'fibonacci-ordinay-loop 0 100)

(printf "~a\n"(function-equal? fibonacci fibonacci-recursion 100))
(printf "~a\n"(function-equal? fibonacci fibonacci-ordinay-loop 100))
(printf "~a\n"(function-equal? fibonacci fibonacci-ordinay-tail-recursion 100))
(printf "~a\n"(function-equal? fibonacci fibonacci-memoized 100))

(time (fibonacci 1000000))
(time (fibonacci-recursion 1000000))
(time (fibonacci-memoized 1000000))
(time (fibonacci 1000001))
(time (fibonacci-recursion 1000001))
(time (fibonacci-memoized 1000001))
(time (fibonacci-memoized 1000000))
(time (fibonacci-ordinay-loop 100000))
(time (fibonacci-ordinay-tail-recursion 100000))


; (time (fibonacci 10000000))
; (time (fibonacci-memoized 10000000))
