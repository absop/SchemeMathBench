(load "vector-mul.ss")

(define odd!!1
  (lambda (min max)
    (if (even? min) (set! min (1- min)))
    (let ([vlen (1+ (floor (/ (- max min) 2)))])
      (let ([v (make-vector vlen)])
        (let loop ([index 0] [val min])
          (if (> val max)
              (vector-mul v (vector-length v))
              (let ([next (1+ index)])
                (vector-set! v index val)
                (loop next (+ val 2)))))))))

(define odd!!2
  (lambda (min max)
    (let loop ([n (if (even? min) (1- min) min)] [res 1])
      (if (> n max)
          res
          (loop (+ n 2) (* res n))))))

(define factorial3
  (lambda (n)
    (define (half-list n)
      (let loop ([n n][ls '()])
        (if (= n 0)
            ls
            (loop (floor (/ n 2)) (cons n ls)))))
    (define (odd!! min max)
      (if (> (- max min) 20) (odd!!1 min max) (odd!!2 min max)))
    (let loop ([res 1] [ls (half-list n)] [expo 0])
      (if (> (length ls) 1)
          (let ([curr (car ls)] [next (cdr ls)])
            (loop (* (expt (odd!! (+ curr 2) (car next))
                           (length next))
                     res)
                  next
                  (+ expo curr)))
          (* res (expt 2 expo))))))
