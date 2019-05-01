;; -*- no-byte-compile: t; -*-
;;; feature/lsp/packages.el

(package! lsp-mode)

(when (featurep! :feature syntax-checker)
  (package! lsp-ui))

(when (featurep! :completion company)
  (package! company-lsp))
