(time (system "gcc -o gfib.so gfib.c -O2 -s -fPIC -shared"))
(time (system "tcc -o tfib.so tfib.c -s -fPIC -shared"))

(load-shared-object "gfib.so")
(load-shared-object "tfib.so")

; gfib is exactly the same as tfib
(define gfib (foreign-procedure "gfib" (int) int))
(define tfib (foreign-procedure "tfib" (int) int))
(define sfib
  (lambda (n)
    (if (< n 2)
        n
        (+ (sfib (- n 1))
           (sfib (- n 2))))))

(time (gfib 40))
(time (tfib 40))
(time (sfib 40))

#!eof
(time (system "gcc -o gfib.so gfib.c -O2 -s -fPIC -shared"))
    no collections
    0.000000000s elapsed cpu time
    0.259551000s elapsed real time
    64 bytes allocated
(time (system "tcc -o tfib.so tfib.c -s -fPIC -shared"))
    no collections
    0.000000000s elapsed cpu time
    0.065528500s elapsed real time
    48 bytes allocated
(time (gfib 40))
    no collections
    0.671875000s elapsed cpu time
    0.664039700s elapsed real time
    0 bytes allocated
(time (tfib 40))
    no collections
    1.328125000s elapsed cpu time
    1.339470400s elapsed real time
    0 bytes allocated
(time (sfib 40))
    no collections
    1.406250000s elapsed cpu time
    1.412271600s elapsed real time
    0 bytes allocated
[Finished in 4.0s]
