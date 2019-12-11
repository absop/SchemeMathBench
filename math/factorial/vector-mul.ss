
; [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
; [10, 18, 24, 28, 30]
; [300, 504, 24]
; [7200, 504]
; [3628800]
; 乘积不变，乘数位数差越小乘得越快

(define vector-mul
  (let ([vector-mul
         (lambda (v len)
           (let shrink ([len (1- len)])
             (cond
               [(> len 0)
                (let loop ([l 0] [r len])
                  (if (< l r)
                      (let ([val (* (vector-ref v l)
                                    (vector-ref v r))])
                        (vector-set! v l val)
                        (loop (1+ l) (1- r)))
                      (shrink (fxdiv len 2))))]
               [(= len 0) (vector-ref v 0)]
               [(< len 0) 1])))])
    (case-lambda
      [(v) (vector-mul v (vector-length v))]
      [(v len) (vector-mul v len)])))

; 2 是一个神奇的数字，我们可以通过不断平方来实现快速幂运算
; 通过二进制位，也可以对多个各具有不同幂次的数进行幂乘运算
;   a1^7 * a2^6 * a3^5 * a4^4 * a5^3 * a6^2 * a7^1
;    111,   110,   101,   100,   011,   010,   001
; = ((a1 * a2 * a3 * a4)^2 * (a1 * a2 * a5 * a6))^2
; * (a1 * a3 * a5 * a7)

(define vector-pow-mul
  (lambda (pairs)
    (define length (vector-length pairs))
    (define v (make-vector length))
    (define number 0)
    (define result 1)
    (define filter-numbers-with-bit
      (lambda (nth)
        (define (one-by-one pair)
          (when (logbit? nth (cdr pair))
                (vector-set! v number (car pair))
                (set! number (1+ number))))
        (set! number 0)
        (vector-for-each one-by-one pairs)))
    (if (> length 0)
        (let ([maxexp (cdr (vector-ref pairs (1- length)))])
          (let loop ([i (1- (integer-length maxexp))])
            (when (>= i 0)
                  (filter-numbers-with-bit i)
                  (set! result (* result result))
                  (set! result (* result (vector-mul v number)))
                  (loop (1- i)) ))
          result)
        1)))
