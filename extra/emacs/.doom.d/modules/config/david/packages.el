;; -*- no-byte-compile: t; -*-
;;; config/david/packages.el

(package! ripgrep)
(package! helm-rg)

;; (package! doom-themes :recipe (:fetcher github :repo "dcao/emacs-doom-themes"))

(when (featurep! :tools magit)
  (package! forge)
  (disable-packages! magithub))

(when (featurep! :tools lsp)
  (package! flycheck-rust :disable t))

(when (featurep! :lang org)
  (package! ox-tufte)
  (package! helm)
  (package! org-journal)
  (package! helm-org-rifle))

(when (featurep! :app rss)
  (package! elfeed-web))
