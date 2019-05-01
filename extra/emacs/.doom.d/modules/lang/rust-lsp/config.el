;;; lang/rust/config.el -*- lexical-binding: t; -*-

;;
;; Plugins
;;

(def-package! rust-mode
  :mode "\\.rs$"

  :config
  (setq rust-indent-method-chain t))

(add-hook 'rust-mode-hook #'lsp-mode)
(add-hook 'lsp-mode-hook #'lsp-ui-mode)
