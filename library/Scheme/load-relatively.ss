(define (path-join dir name)
  (cond
    [(or (string=? dir "") (string=? dir ".")) name]
    [(directory-separator?
       (string-ref dir (fx- (string-length dir) 1)))
     (format "~a~a" dir name)]
    [(format "~a/~a" dir name)]))

(define (find-library path)
  (cond
    [(file-exists? path) path]
    [(path-absolute? path) #f]
    [(let loop ([ldirs (library-directories)])
       (if (not (null? ldirs))
           (let ([path (path-join (caar ldirs) path)])
             (or (and (file-exists? path) path)
                 (loop (cdr ldirs))))
           #f))]
    [else #f]))

(define (load-relatively path)
  (cond
    [(find-library path) =>
     (lambda (path)
       (let ([origin-dir (cd)]
             [target-dir (path-parent path)]
             [target-name (path-last path)])
         (cd target-dir)
         (load (path-join (cd) target-name))
         (cd origin-dir)))]
    [(error 'load-relatively
       "failed for ~a: no such file or directory" path)]))
