(define U
  (lambda (u)
    (lambda (x) (lambda (y) ((x ((u u) x)) y)))))

(define Y (U U))

(define factorial-recursion
  (lambda (n)
    (if (= n 0)
        1
        (* n (factorial-recursion (- n 1))))))

(define factorial-YC
  (Y (lambda (f)
       (lambda (n)
         (if (= n 0)
             1
             (* n (f (- n 1))))))))

(define factorial-loop1
  (lambda (n)
    (let loop ([result 1][i n])
      (if (= i 0)
          result
          (loop (* result i) (1- i))))))

(define factorial-loop2
  (lambda (n)
    (let loop ([result 1][i 2][j n])
      (if (< i j)
          (loop (* result (* i j))
                (1+ i)
                (1- j))
          (if (= i j)
              (* result i)
              result)))))

(define factorial-tail-recursion1
  (lambda (n)
    (define help
      (lambda (result n)
        (if (= n 0)
            result
            (help (* result n) (- n 1)))))
    (help 1 n)))

(define factorial-tail-recursion2
  (lambda (n)
    (define help
      (lambda (result i j)
        (if (< i j)
            (help (* result (* i j))
                  (1+ i)
                  (1- j))
            (if (= i j)
                (* result i)
                result))))
    (help 1 2 n)))
