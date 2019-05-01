;;; lang/rust/config.el -*- lexical-binding: t; -*-

;;
;; Plugins
;;

(def-package! lsp-mode)

(def-package! lsp-ui
  :when (featurep! :feature syntax-checker)
  :after lsp-mode
  :config
  (setq lsp-ui-flycheck-enable t)
  :hook
  (lsp-mode . lsp-ui-mode)
  (lsp-ui-mode . flycheck-mode))

(def-package! company-lsp
  :when (featurep! :completion company)
  :after (lsp-mode lsp-ui)
  :config
  (setq company-backends '(company-lsp))
  (setq company-lsp-async t))
