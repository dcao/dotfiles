;;; lang/fountain/config.el -*- lexical-binding: t; -*-

(def-package! j-mode
  :mode "\\.ij[rstp]$"
  :config
  (setq j-console-cmd "j8")
  (setq j-console-cmd-args '("--console"))
  (custom-set-faces
   '(j-verb-face ((t (:foreground "#FB4934"))))
   '(j-adverb-face ((t (:foreground "#94961E"))))
   '(j-conjunction-face ((t (:foreground "#83A598"))))
   '(j-other-face ((t (:foreground "#8A8A8A")))))
  (map! :localleader
        :map j-mode-map
        "!" #'j-console
        ":" #'helm-j-cheatsheet
        "h" #'j-help-lookup-symbol
        "H" #'j-help-lookup-symbol-at-point
        "l" #'j-console-execute-line
        "r" #'j-console-execute-region
        "b" #'j-console-execute-buffer))
