;;; lang/fountain/config.el -*- lexical-binding: t; -*-

(def-package! idris-mode
  :mode "\\.idr$"

  :config
  (idris-define-evil-keys))
