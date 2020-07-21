;;; basic_init.el --- a basic init.el file -*- lexical-binding: t; -*-
;;; Commentary:
;;; Stuff

;;; Code:
;; --- PACKAGE INITIALIZATION
(let ((gc-cons-threshold most-positive-fixnum))

  ;; Set comp-deferred-compilation so that we can asynchronously compile faster
  ;; versions of our libs when using gccemacs
  (setq comp-deferred-compilation t)

  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") 

  ;; straight.el bootstrap
  (defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
        (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

  ;; Install dependencies
  (straight-use-package 'delight)
  (straight-use-package 'use-package)
  (setq-default
   use-package-always-ensure nil
   straight-use-package-by-default t)

  ;; If config is pre-compiled, then load that
  (if (file-exists-p (expand-file-name "config.elc" user-emacs-directory))
      (load-file (expand-file-name "config.elc" user-emacs-directory))
    ;; Otherwise use org-babel to tangle and load the configuration
    (use-package org :ensure org-plus-contrib)
    (org-babel-tangle-file (expand-file-name "config.org" user-emacs-directory) (expand-file-name "config.el" user-emacs-directory) "emacs-lisp")
    (load-file (expand-file-name "config.el" user-emacs-directory)))
  (garbage-collect))
