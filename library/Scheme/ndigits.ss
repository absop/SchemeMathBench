;;; Chez's built-in logarithm function
;;; is quite slow for big integers, so I
;;; written the following logarithm function
;;; to compute (log base n) approximately.

(define logarithm
  (lambda (base n)
    (let ([binary-length (integer-length n)])
      (define (decimal-part)
        (if (< binary-length 64)
            (/ n (ash 1 (1- binary-length)))
            (/ (bitwise-bit-field n
                                  (- binary-length 64)
                                  binary-length)
               (ash 1 63))))
      (* (+ binary-length -1 (log (decimal-part) 2))
         (log 2 base)))))

(define ndigits
  (let ([$ndigits
         (lambda (n base)
           (if (> n 1)
               (let ([logxy (logarithm base n)])
                 (let ([result (ceiling logxy)])
                   (flonum->fixnum
                     (if (fl<= (abs (- logxy result)) 1e-15)
                         (1+ result)
                         result))))
               1))])
    (case-lambda
      [(n) ($ndigits n 10)]
      [(n base) ($ndigits n base)])))

#!eof
(load "for-loop.ss")

(for i from 1 to 101
     (printf "ndigits(~a)  = ~a\n" i (ndigits i)))
