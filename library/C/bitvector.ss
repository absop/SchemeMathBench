; gcc -O3 -fPIC -shared -o bitvector.so bitvector.c

(load-shared-object "bitvector.so")


(define-ftype bitvector int)

(define-syntax check-bit
  (syntax-rules ()
    [(_ caller fill)
     (unless (and (integer? fill)
                  (or (= fill 0)
                      (= fill 1)))
             (error caller "fill can only be 0/1"))]))


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
      (check-bit 'bitvector-fill! fill)
      (c-bitvector-fill! v fill))))

(define make-bitvector
  (let ([c-make-bitvector
         (foreign-procedure "make_bitvector" (int int) (* bitvector))])
    (case-lambda
      [(n) (c-make-bitvector n 0)]
      [(n fill)
       (check-bit 'make-bitvector fill)
       (c-make-bitvector n fill)])))

(define free-bitvector
  (foreign-procedure "free_bitvector" ((* bitvector)) void))
