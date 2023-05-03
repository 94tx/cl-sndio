(defsystem "cl-sndio"
  :depends-on ("cffi" "trivial-garbage")
  :components ((:file "package")
	       (:file "ffi")
	       (:file "sndio")))
