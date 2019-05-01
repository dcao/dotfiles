;;; lang/fountain/config.el -*- lexical-binding: t; -*-

(def-package! fountain-mode
  :mode "\\.fountain$"

  :config
  (turn-on-olivetti-mode))

(def-package! olivetti)
