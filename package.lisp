(defpackage :sndio
  (:use :common-lisp :cffi)
  (:export :open-handle
	   :close-handle))
