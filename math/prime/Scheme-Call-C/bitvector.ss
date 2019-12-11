; gcc -O3 -fPIC -shared -o bitvector.so bitvector.c
(load-shared-object "../../../library/C/bitvector.so")

(define-ftype bitvector
              (struct
                [size integer-64]
                [bits (* int)]))

(define bitvector-ref
  (foreign-procedure "bitvector_ref" ((* bitvector) int) boolean))

(define bitvector-set!
  (foreign-procedure "bitvector_set" ((* bitvector) int) void))

(define bitvector-reset!
  (foreign-procedure "bitvector_reset" ((* bitvector) int) void))

(define bitvector-fill!
  (let ([c-bitvector-fill!
         (foreign-procedure "bitvector_fill" ((* bitvector) int) void)])
    (lambda (v fill)
      (unless (and (integer? fill)
                   (or (= fill 0)
                       (= fill 1)))
              (error 'make-bitvector "fill can only be 0/1"))
      (c-bitvector-fill! v fill))))

(define bitvector-free!
  (foreign-procedure "bitvector_free" ((* bitvector)) void))

(define make-bitvector
  (let ([c-make-bitvector
         (foreign-procedure "make_bitvector" (int int) (* bitvector))])
    (case-lambda
      [(n) (c-make-bitvector n 2)]
      [(n fill)
       (unless (and (integer? fill)
                    (or (= fill 0)
                        (= fill 1)))
               (error 'make-bitvector "fill can only be 0/1"))
       (c-make-bitvector n fill)])))
