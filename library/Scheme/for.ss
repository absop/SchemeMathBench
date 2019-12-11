(define-syntax for
  (lambda (x)
    (syntax-case x (in range : =)
      [(for k in range(end): expr ...)
       #'(let ([end* end])
          (let loop ([k 0])
            (when (<= k end*)
                  expr ...
                  (loop (+ k 1)))))]
      [(for k = (end): expr ...)
       #'(let ([end* end])
          (let loop ([k 0])
            (when (<= k end*)
                  expr ...
                  (loop (+ k 1)))))]

      [(for k in range(start end): expr ...)
       #'(let ([end* end])
          (let loop ([k start])
            (when (<= k end*)
                  expr ...
                  (loop (+ k 1)))))]
      [(for k = (start end): expr ...)
       #'(let ([end* end])
          (let loop ([k start])
            (when (<= k end*)
                  expr ...
                  (loop (+ k 1)))))]

      [(for k in range(start end step): expr ...)
       #'(let ([end* end][step* step]
               [op (if (> step 0) <= >=)])
          (let loop ([k start])
            (when (op k end*)
                  expr ...
                  (loop (+ k step*)))))]
      [(for k = (start end step): expr ...)
       #'(let ([end* end][step* step]
               [op (if (> step 0) <= >=)])
          (let loop ([k start])
            (when (op k end*)
                  expr ...
                  (loop (+ k step*)))))])))
