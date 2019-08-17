;;; basic_init.el --- a basic init.el file -*- lexical-binding: t; -*-
;;; Commentary:
;;; Stuff

;;; Code:
;; --- PACKAGE INITIALIZATION
(let ((gc-cons-threshold most-positive-fixnum))

  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") 

  ;; Set repositories
  (require 'package)
  (setq-default
   load-prefer-newer t
   package-enable-at-startup nil)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
  (package-initialize)

  ;; Install dependencies
  (unless (and (package-installed-p 'delight)
               (package-installed-p 'use-package))
    (package-refresh-contents)
    (package-install 'delight t)
    (package-install 'use-package t))
  (setq-default
   use-package-always-ensure t)

  ;; If config is pre-compiled, then load that
  (if (file-exists-p (expand-file-name "config.elc" user-emacs-directory))
      (load-file (expand-file-name "config.elc" user-emacs-directory))
    ;; Otherwise use org-babel to tangle and load the configuration
    (use-package org :ensure org-plus-contrib)
    (org-babel-load-file (expand-file-name "config.org" user-emacs-directory)))
  (garbage-collect))
