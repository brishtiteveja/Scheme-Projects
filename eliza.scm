(define (সুন্দরী valobasa)
	(cond ((equal? valobasa "তোমাকে ভালবাসি") "এক থাপ্পর খাবি")
                  ((equal? valobasa "তোমাকে বিয়ে করতে চাই") "তোর মত শয়তানকে আমি করব বিয়ে ! ওহ মাই গড .")
                  ((equal? valobasa "তোমার রূপের রহস্য কি?") "বলবা না |")
		  ((equal? valobasa "তোমার নাম কি?") "সুন্দরী")
		  ((equal? valobasa "তুমি অনেক সুন্দর") "যাহ")
		  ((equal? valobasa ";)") "এসব কি?")
      		  ((equal? valobasa "চল ঘুরতে যাই") "চল চল")
		  ((equal? valobasa "কিছু কিনতে চাও?") "তোমার কি অনেক টাকা?")
		  ((equal? valobasa "রেস্টুরেন্টে যেতে চাও?") "খুব চাই")
		  ((equal? valobasa "তোমার হাত ধরি") "না না | তুমি অনেক দুষ্টু তো")
	)
)
;;
;;
;;
(define *r1*
	'(1 (What sports will you play in this school ?) (Who encouraged you to take this examination) (I see))
)
(define *r2* 
	'(1 (* Why do you want) (Why do you think so ?) (I see))
)
(define *r3*
	'(1 (* why do you like) (Why do you think so ?) (I see))
)
(define *r4*
	'(1 (What doest theat suffest to you ?) (Why do you think so ?) (What kind of person do you think you are ?) (I see))
)
(define *r5*
	'(1 (Do you know of Winbldon ?) (Do you like tennis ?) (Do you play other sports?) (I see))
)
(define *r6* 
	'(1 (Can you use computers ?) (When do you begin to use computers ?) (I see))
)
(define *r7*
	'(1 (What are you interested in ?) (I see))
)
(define *r8*
	'(1 (Does your father approve of your going to this school ?) 
	(Also does your teacher approve of your going to this school ?) (I see)
	 )
)

;;*resp*
(define *resp*
	(list *r1* *r2* *r3* *r4* *r5* *r6* *r7* *r8*)
)


;;starting eliza
;;interview

(define (interview)
	(display "Why do you take the examination of this school ? ")
	(newline)
	(do   	(	(key '())
	 		(msg (read-sentence) (read-sentence) )
			(old '() msg)	 )
	 	(	(member (car msg) '(goodbye bye exit quit end))
		 						'goodbye)
		(cond 	(
				(equal? msg old)
					(display " Please do not repeat yourself ")
			)
			(else	(set! key (keysearch msg))
				(print-list (
					reply (word-conjugate (cdr key)) (car key)
					    )
				)
			)
		)
			
		(newline)
	)
)

;; (read-sentence)
;; I like this school . ==> (I like this school)
;;

(define (read-sentence)
	(display ":-) ")
	(do ( (token (read) (read))
	      (sentence '() sentence)
	    ) 
	    ((eq? token '/) sentence) 
	    (set! sentence (append sentence (list token) )  )
	)
)

;;(print-list '(I see)) ==> I see
;;

(define (print-list lst)
	(cond ((null? lst) (display " "))
	      (else (display " ") (write (car lst)) (print-list (cdr lst)))
	)
)
(define *dic*
	'((I conj you) (You conj me) (me conj you)
	  (my conj your) (your conj my) (am conj are)
	  (I key want) (I key like) (I want 2)
	  (I like 3) (I key2 4) (tennis key 5)
	  (computers key 6) (computer key 6)
	  (interest key 7) (interesting key 7)
	  (interested key 7) (father key 8)
	 )
)


;;(nth '(1 2 3 4 5) 4) ==> 5
;;
(define (nth foo baz)
	(cond ((null? foo) '())
	      ((= baz 0) (car foo))
	      (else (nth (cdr foo) (- baz 1)))
	)
)

;;(getdic 'I 'want) ==> 2
;;

(define (getdic foo baz)
	(do ((jisyo *dic* jisyo))
	    ((or (null? jisyo)
	         (and (equal? foo (caar jisyo)) 
		      (equal? baz (cadar jisyo))))
	    (if (null? jisyo) jisyo (nth (car jisyo) 2)))
	    (set! jisyo (cdr jisyo))
	)
)



;;(get 'I 'want) ==> 2
;;
(define (get x y)
	(let ((z (getdic x y))) (if (null? z) 1 z))
)


;; (keyphrase 'I '(want to computers) '(want))
;;     ==>   (2 to computers)
;;
(define (keyphrase word msg thiskey)
	(do ((return '()))
	    ((null? thiskey) return)
	    (cond ((number? thiskey)
	          	(set! return (cons thiskey msg))
			(set! thiskey '())
		  )
		  (else (set! thiskey (getdic word (car msg))) 
		  	(set! msg (cdr msg))
	          )
	    )
        )
)

;;(keysearch '(I like this school)) =>(3 this school)
;;
(define (keysearch msg)
	(do ((keynum 1 keynum) (thiskey 1 thiskey) (left '() left) (word '() word))
	    ((null? msg) (cons keynum left))
	    (set! word (car msg))
	    (if (number? word)
	    	(set! thiskey 1)
		(set! thiskey (getdic word 'key))
	    )
	    (cond ((not (number? thiskey))
	    		(set! thiskey 
				(keyphrase word (cdr msg) thiskey))
			(cond ((null? thiskey)
				(set! msg (cdr msg))
				(set! thiskey (get word 'key2))
			      )
			      (else (set! msg (cdr thiskey))
			      	    (set! thiskey (car thiskey))
			      )
			)
		  )
	 	  (else (set! msg (cdr msg)))
	    )
	    (cond ((> thiskey keynum) (set! keynum thiskey) (set! left msg)))
	)
)

;;(word-conjugate '(I like)) ==> (you like)
;;

(define (word-conjugate oldt) 
	(do ((new '() new) (w '() w) (w2 '() w2))
	    ((null? oldt) new)  
	    (set! w (car oldt))  
	    (cond ((number? w) (set! w2 '()) (set! w '(,w)))
	     	  (else (set! w2 (getdic w 'conj))
		    	(set! w '(,w)))) 
	    (if (null? w2) (set! new (append new w)) (set! new (append new '(,w2))))
	    (set! oldt (cdr oldt))   
	) 
)



;;(reply '(me) 3) ==> (Why do you like me?)
;;

(define (reply new keynum)
	(let* ((res (nth *resp* (- keynum 1)))
		(new (append new '(?)))
		(out (nth (cdr res) (- (car res) 1))))     
     	     (cond ((null? out) 
	     		 (set-car! res 2)
      	     		 (set! out (cadr res)))
		   (else (set-car! res (+ (car res) 1))))
	     (if (equal? (car out) '*)
	     	(set! out (append (cdr out) new)) out)
	)
)


