(let ((hdl    (sndio:open-handle "default" :play))
      (params (sndio::init-parameters)))
  (sndio::set-parameters hdl params)
  (sndio:close-handle hdl))
