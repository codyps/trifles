;;;; This file is project 1 for CS 314 for Spring 2011, taught by Prof. Steinberg

;;;; The assignment is to fill in the definitions below, adding your code where ever you see
;;;; the comment 
     ;;  fill in here
;;;; to make each function do what its comments say it should do
;;;; You may also add your own functions, as long as each function has a comment like the ones below.
;;;; You may not make any other changes to this code.

;;;; See the assignment on Sakai for examples and further information, including due date.

;;;; code for a program to create closures that generate ascii patterns

;;; patterns: a pattern is represented by a list of 4 elements:  'pattern, numrows, numcols and fn
;;; 'pattern is just the symbol pattern
;;; fn is a function (ie a closure) of two parameters:  row, column that returns the character
;;;   at the given row and column of the pattern.  If row is out of bounds ie row<0 or row>=numrows,or
;;;   similarly for col, fn returns the character #\. (a period character)
;;; numrows is the number of rows in the pattern
;;; numcols is the number of columns in the pattern
;;; the following are functions to create and access a pattern
;;; note that make-pattern adds bounds checking to fn
(define (make-pattern numrows numcols fn)
  (list 'pattern numrows numcols (add-check fn numrows numcols)))
(define (pattern-numrows pattern)(cadr pattern))
(define (pattern-numcols pattern)(caddr pattern))
(define (pattern-fn pattern) (cadddr pattern))

;;; Helper function for for-n.
(define (for-n- start stop fn ret)
  (if (> start stop)
      (reverse ret)
      (for-n- (+ start 1) stop fn (cons (fn start) ret))))

;;; for-n takes three arguments:  start and stop, which are numbers, and fn which is a function of one argument
;;; it calls fn several times, first with the argument start, then with start+1 then ... finally
;;; with stop.  If start>stop, for-n simply returns the empty list without doing any calls to fn.
;;; for-n returns a list of the values that the calls to fn return
(define (for-n start stop fn)
  (for-n- start stop fn (list)))
  ;; filled in here
  
;;; range-check takes 4 arguments:  row, numrows, col, numcols. It checks if
;;;  0 <= row < numrows and similarly for col and numcol.  If both row and col are in range
;;;  range-check returns #t, otherwise #f
(define (range-check row numrows col numcols)
  (and (<= 0 row) (< row numrows) (<= 0 col) (< col numcols)))

;;; add-check takes 3 arguments: fn, numrows and numcols.  Fn is a function of two numbers, row and col
;;; add-check returns a new function fn2 that also takes two numbers as arguments, but first does a range check
;;; and if row or col is out of range fn2 returns #\., else it returns the result of (fn row col)
(define (add-check fn numrows numcols)
  (lambda (row col)
    (if (range-check row numrows col numcols)
        (fn row col)
        #\.)))

;;; display-window prints out the characters that make up a rectangular segment of the pattern
;;;    startrow and endrow are the first and last rows to print, similarly for startcol and endcol
;;; The last thing display-window does is to call (newline) to print a blank line under the pattern segment
(define (display-window start-row stop-row start-col stop-col pattern)
  (for-n start-row stop-row 
         (lambda (r)
           (for-n start-col stop-col 
                  (lambda (c)
                    (display ((pattern-fn pattern) r c))))
           (newline)))
  (newline))

;;; charpat take one argument, a character, and returns a 1-row, 1-column pattern consisting of that character
(define (charpat char)
  (make-pattern 1 1 (lambda (row col)
                      char)))

;;; sw-corner returns a pattern that is a size x size square, in which the top-left to bottom-right diagonal 
;;; and everything under it is the chhracter * and everything above the diagonal is a space character
(define (sw-corner size)
  (make-pattern size
                size
                (lambda (row col)
                  (if (>= row col)
                      #\*
                      #\space))))


;;; repeat-cols returns a pattern made up of nrepeats copies of pattern, appended horizontally (left and right of each other)
(define (repeat-cols nrepeats pattern)
  (make-pattern (pattern-numrows pattern) 
                (* nrepeats (pattern-numcols pattern)) 
                ; the function just calls the function repeat-cols received, but 
                ; use modulus to select the right position.
                (lambda (row col) ((pattern-fn pattern) row (modulo col (pattern-numcols pattern)))) ))

;;; repeat-rows returns a pattern made up of nrepeats copies of pattern, appended vertically (above and below each other)
(define (repeat-rows nrepeats pattern)
  (make-pattern (* nrepeats (pattern-numrows pattern))
                (pattern-numcols pattern)
                (lambda (row col) ((pattern-fn pattern) (modulo row (pattern-numrows pattern)) col))
  )
)
     

;;; append cols returns the pattern made by appending pattern2 to the right of pattern1
;;; the number of rows in the resulting pattern is the smaller of the number of rows in pattern1 and patten2
(define (append-cols pattern1 pattern2)
  (make-pattern (min (pattern-numrows pattern1) (pattern-numrows pattern2))
                (+   (pattern-numcols pattern1) (pattern-numcols pattern2))
                (lambda (row col) (if (< col (pattern-numcols pattern1))
                                      ((pattern-fn pattern1) row col)
                                      ((pattern-fn pattern2) row (- col (pattern-numcols pattern1)))
                ))
  )
)

;;; append-rows returns the pattern made by appending pattern2 to the below pattern1
;;; the number of columns in the resulting pattern is the smaller of the number of columns in pattern1 and patten2
(define (append-rows pattern1 pattern2)
  (make-pattern (+   (pattern-numrows pattern1) (pattern-numrows pattern2))
                (min (pattern-numcols pattern1) (pattern-numcols pattern2))
                (lambda (row col) (if (< row (pattern-numrows pattern1))
                                      ((pattern-fn pattern1) row col)
                                      ((pattern-fn pattern2) (- row (pattern-numrows pattern1)) col))
                )
  )
)

;;; flip-cols returns a pattern that is the left-right mirror image of pattern
(define (flip-cols pattern)
  (make-pattern (pattern-numrows pattern) (pattern-numcols pattern)
                (lambda (row col) ((pattern-fn pattern)
                                   row 
                                   (+ (pattern-numcols pattern) (- -1 col))
                                  )
                )
  )
)

;;; flip-rows returns a pattern that is the up-down mirror image of pattern
(define (flip-rows pattern)
  (make-pattern (pattern-numrows pattern) (pattern-numcols pattern)
                (lambda (row col) ((pattern-fn pattern)
                                   (+ (pattern-numrows pattern) (- -1 row))
                                   col
                                  )
                )
  )
)

;;; The following is the provided test cases typed up.
(define pa (charpat #\a))
(define pb (charpat #\b))
(define ab (append-cols pa pb))
(define cde (append-cols (charpat #\c)(append-cols (charpat #\d)(charpat #\e))))
(define abcd (append-rows ab cde))
(define (test)
  (display-window 0 0 0 0 pa)
  (display-window 0 0 0 1 pa)
  (display-window 0 1 0 1 ab)
  (display-window 0 2 0 2 abcd)
  (display-window 0 1 0 2 cde)
  (display-window 0 3 0 3 (sw-corner 4))
  (display-window 0 3 0 3 (flip-rows (sw-corner 4)))
  (display-window 0 3 0 3 (flip-cols (sw-corner 4)))
 
  (let (
        (p1 (append-rows ab (flip-cols ab)))
       )
    (display-window 0 2 0 4 (append-cols p1 (flip-rows p1)))
  )
)