; (eval-when (compile) (optimize-level 3))

(load "factorial1.ss")
(load "factorial2.ss")
(load "factorial3.ss")
(load "simple-factorial.ss")

(define (correct? function)
  (define (factorial n)
    (let loop ([i n] [result 1])
      (if (zero? i)
          result
          (loop (1- i) (* result i)))))
  (let loop ([n 1000])
    (let ([num1 (factorial n)] [num2 ((eval function) n)])
      (if (= num1 num2)
          (if (> n 0)
              (loop (1- n))
              (printf "The funtion ~a is correct for \
                       all numbers less than 1000\n" function))
          (printf "The funtion ~a is incorrect at: ~a\n" function n)))))


(load "../../library/Scheme/ndigits.ss")

(define benchmark
  (lambda (function)
    (time (set! result ((eval function) 100000)))
    (printf "~a: ~a\n" function (ndigits result 10))))


(correct? 'factorial!)
(correct? 'factorial1)
(correct? 'factorial2)
(correct? 'factorial3)
(correct? 'factorial-recursion)
(correct? 'factorial-YC)
(correct? 'factorial-loop1)
(correct? 'factorial-loop2)
(correct? 'factorial-tail-recursion1)
(correct? 'factorial-tail-recursion2)

(benchmark 'factorial!)
(benchmark 'factorial1)
(benchmark 'factorial2)
(benchmark 'factorial3)
(benchmark 'factorial-recursion)
(benchmark 'factorial-YC)
(benchmark 'factorial-loop1)
(benchmark 'factorial-loop2)
(benchmark 'factorial-tail-recursion1)
(benchmark 'factorial-tail-recursion2)


#!eof
