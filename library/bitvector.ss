;;; bitvector.ss

(define make-bitvector
  (case-lambda
    [(nbit)
     (make-bytevector (1+ (fxarithmetic-shift-right nbit 3)))]
    [(nbit fill)
     (make-bytevector (1+ (fxarithmetic-shift-right nbit 3))
                      (if (= fill 1) 255 0))]))

(define bitvector-ref
  (lambda (bitvec nth)
    (let ([nbyte (fxarithmetic-shift-right nth 3)])
      (logbit? (fxand nth 7) (bytevector-u8-ref bitvec nbyte)))))

(define bitvector-set!
  (lambda (bitvec nth)
    (let ([nbyte (fxarithmetic-shift-right nth 3)])
      (let ([old (bytevector-u8-ref bitvec nbyte)])
        (let ([new (logbit1 (fxand nth 7) old)])
          (bytevector-u8-set! bitvec nbyte new))))))

(define bitvector-reset!
  (lambda (bitvec nth)
    (let ([nbyte (fxarithmetic-shift-right nth 3)])
      (let ([old (bytevector-u8-ref bitvec nbyte)])
        (let ([new (logbit0 (fxand nth 7) old)])
          (bytevector-u8-set! bitvec nbyte new))))))
