;;窗口设置
(setq initial-frame-alist
     (let* ((screen-width (display-pixel-width))
            (screen-height (display-pixel-height))
            (frame-width (* (frame-char-width) 80))
            (frame-height (* (frame-char-height) 43)))
       `((width . 80)
         (height . 43)
         (top . ,(/ (- screen-height frame-height) 2))
         (left . ,(/ (- screen-width frame-width) 2)))))
