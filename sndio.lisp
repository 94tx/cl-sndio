(in-package :sndio)

(defclass parameters ()
  ((pointer :type (:pointer (:struct sio_par))
	    :initarg :pointer)))
(defclass handle ()
  ((pointer :type :pointer
	    :initarg :pointer)
   (parameters :type parameters)))

(defun init-parameters ()
  (let ((ptr (foreign-alloc '(:pointer (:struct sio_par)))))
    (sio-initpar ptr)
    (tg:finalize (make-instance 'parameters :pointer ptr)
		 (lambda ()
		   (foreign-free ptr)))))

(defmethod set-parameters ((hdl handle)
			   (par parameters))
  ;; We keep the parameters in the handle object to avoid it getting
  ;; garbage-collected until the handle itself is garbage-collected,
  ;; in case we need it.
  (setf (slot-value hdl 'parameters) par)
  (let ((res (sio-setpar (slot-value hdl 'pointer)
			 (slot-value par 'pointer))))
    (if (= res 1)
	nil
	(error "TODO: what's the error here !?"))))

(defun open-handle (device mode &key (non-blocking? nil))
  (let* ((mode-no
	  (if (numberp mode)
	      mode
	      (ccase mode
		((:play) +sio_play+)
		((:record :rec) +sio_rec+)
		((:play+record :play+rec)
		 (logior +sio_play+ +sio_rec+)))))
	 (non-blocking?-no
	   (if (null non-blocking?) 0 1))
	 (foreign-handle (sio-open device mode-no non-blocking?-no)))
    (if (null-pointer-p foreign-handle)
	(error "TODO: show errno here?")
	(let ((hdl (make-instance 'handle :pointer foreign-handle)))
	  (tg:finalize hdl (lambda ()
			     (format T "finalizing handle")
			     (sio-close foreign-handle)))))))

(defmethod close-handle ((hdl handle))
  (with-slots (pointer) hdl
    (if (null-pointer-p pointer)
	nil
	(progn
	  (tg:cancel-finalization hdl)
	  (sio-close pointer)
	  (setf pointer (null-pointer))
	  t))))
