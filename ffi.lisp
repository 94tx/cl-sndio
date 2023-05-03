(in-package :sndio)

(cffi:define-foreign-library libsndio
  (:unix (:or "libsndio.so.7.2" "libsndio.so"))
  (t (:default "libsndio")))
(cffi:use-foreign-library libsndio)

(cffi:defcfun "sio_open" :pointer
  (name :string)
  (mode :unsigned-int)
  (nbio_flag :int))
(cffi:defcfun "sio_close" :void
  (hdl :pointer))

(cffi:defcstruct sio_par
  (bits :unsigned-int)
  (bps  :unsigned-int)
  (sig  :unsigned-int)
  (le   :unsigned-int)
  (msb :unsigned-int)
  (rchan :unsigned-int)
  (pchan :unsigned-int)
  (rate :unsigned-int)
  (appbufsz :unsigned-int)
  (bufsz :unsigned-int)
  (round :unsigned-int)
  (xrun  :unsigned-int))

(cffi:defcfun "sio_initpar" :void
  (par (:pointer (:struct sio_par))))
(cffi:defcfun "sio_setpar" :int
  (hdl :pointer)
  (par (:pointer (:struct sio_par))))
(cffi:defcfun "sio_getpar" :int
  (hdl :pointer)
  (par (:pointer (:struct sio_par))))

(defconstant +SIO_PLAY+ 1
  "Play-only mode: data written will be played by the device.")
(defconstant +SIO_REC+ 2
  "Record-only mode: samples are recorded by the device and must be read.")

(defconstant +SIO_IGNORE+ 0 "pause during xrun")
(defconstant +SIO_SYNC+   1 "resync during xrun")
(defconstant +SIO_ERROR+  2 "terminate on xrun")

