;;; config/default/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "Iosevka" :size 18))
; (setq doom-font (font-spec :family "InputMonoCompressed Medium" :size 19))
(setq doom-variable-pitch-font (font-spec :family "Libre Baskerville" :size 16))
; (setq doom-variable-pitch-font (font-spec :family "Input Serif Compressed Medium" :size 18))
(setq doom-theme 'doom-gruvbox)
;; doom-unicode-font
(setq display-line-numbers-width 4)
(setq-default line-spacing 4)

(set-frame-parameter nil 'internal-border-width 18)

(setq initial-major-mode 'org-mode)
(setq confirm-kill-emacs nil)
(xterm-mouse-mode 1)

;;
;; Config
;;

(after! cc-mode
  (c-add-style
   "dcao"
   '((c-basic-offset . 4)))
  (setq c-default-style "dcao"))

;; Rust
(after! lsp-mode
  (add-hook! 'rust-mode-hook 'lsp-mode))

;; Magit
(def-package! forge
  :after magit
  :bind
  (:map magit-mode-map
    ("`" . forge-dispatch)))

;; Org wrangling
(defvar cao/org-root (concat (getenv "HOME") "/default/org/"))

(defvar cao/org-inbox-template "* TODO %^{Task}
:PROPERTIES:
:CREATED: %U
:END:
%i")

(defvar cao/org-contact-template "* %^{Name}
:PROPERTIES:
:BIRTHDAY: %^{DOB (yyyy-mm-dd)}
:END:
%i")

(defvar cao/org-song-rec-template "** %^{Name}
:PROPERTIES:
:CREATED: %U
:END:
%i")

(defvar cao/org-weekly-review-template "** %(format-time-string \"%Y-%V\")
:PROPERTIES:
:CREATED: %U
:END:
- [ ] Sift inbox
- [ ] Task checkup
  - [ ] Emails?
- [ ] =lt= checkup
- [ ] Self-eval
%?")

(if (featurep! :completion ivy)
  (after! ivy
    ; (setq ivy-re-builders-alist ((t . ivy--regex-plus)))
    (ivy-rich-mode +1)))

(def-package! ox-tufte
  :after org)

(after! elfeed
  (def-package! elfeed-web
    :commands elfeed-web-start
    :config
    (setq httpd-port 3749))

  (setq shr-inhibit-images t))

(after! org
  (def-package! org-contacts)
  (def-package! org-expiry)

  (setq org-agenda-files `(,cao/org-root)
        org-directory cao/org-root
        org-archive-location (concat cao/org-root "archive/%s::")
        org-log-done 'time
        org-log-into-drawer t
        org-expiry-inactive-timestamps t
        org-default-priority ?C
        org-lowest-priority ?D
        org-catch-invisible-edits 'show-and-error
        ;; refile
        org-refile-targets '((org-agenda-files :maxlevel . 3))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm
        ;; contacts
        org-contacts-files `(,(concat cao/org-root "ppl.org"))
        ;; capture
        org-capture-templates
        `(("t" "inbox todo" entry (file ,(concat cao/org-root "inbox.org"))
           ,cao/org-inbox-template)
          ("c" "contact" entry (file ,(concat cao/org-root "inbox.org"))
           ,cao/org-contact-template)
          ("s" "song rec" entry (file+headline ,(concat cao/org-root "lt.org") "Song rec")
           ,cao/org-song-rec-template)
          ("r" "weekly review" entry (file+headline ,(concat cao/org-root "review.org") ,(format-time-string "%Y"))
           ,cao/org-weekly-review-template)))

  (def-package! org-journal
    :defer t
    :custom
    (org-journal-dir (concat cao/org-root "journal/"))
    (org-journal-file-type 'yearly)
    (org-journal-date-format "%a, %B %d, %Y"))

  (setq org-agenda-custom-commands
        '(("t" "test" todo "DONE"
           ((org-agenda-prefix-format "%t k")
            (org-agenda-overriding-header "\ntest\n")))))

  (require 'appt)
  (require 'notifications)
  (appt-activate t)

  (setq appt-message-warning-time 5) ; Show notification 5 minutes before event
  (setq appt-display-interval appt-message-warning-time) ; Disable multiple reminders
  (setq appt-display-mode-line nil)

  ; Use appointment data from org-mode
  (defun cao/build-notifs ()
    (interactive)
    (setq appt-time-msg-list nil)
    (org-agenda-to-appt t nil :deadline :scheduled :timestamp :sexp))

  ; Alarm updating
  ; If Emacs is open at 12am, this will update the notifications then. Otherwise,
  ; it'll update them now.
  ; (run-at-time "12:00am" (* 24 3600) 'cao/build-notifs)
  (add-hook 'after-save-hook
            '(lambda ()
               (if (string-prefix-p cao/org-root (buffer-file-name))
                   (cao/build-notifs))))

  (add-hook 'org-agenda-finalize-hook
            'cao/build-notifs)

  (defun cao/appt-display (min-to-app new-time msg)
    (if (atom min-to-app)
      (notifications-notify :title (concat "org +" min-to-app " min") :body msg)
    (dolist (i (number-sequence 0 (1- (length min-to-app))))
      (notifications-notify :title (concat "org +" (nth i min-to-app) " min") :body (nth i msg)))))

  ; Display appointments as a window manager notification
  (setq appt-disp-window-function 'cao/appt-display)
  (setq appt-delete-window-function (lambda () t))

  (def-package! helm
    ;; If the helm feature is enabled, we don't need to redeclare it
    :unless (featurep! :completion helm)
    :defer t)

  (def-package! helm-org-rifle
    :after (org helm)
    :commands helm-org-rifle-agenda-files
    :config
    (helm-autoresize-mode +1))

  (map! :map org-mode-map
        :ni "<M-right>" #'org-narrow-to-subtree
        :ni "<M-left>" #'widen
        :localleader
        :desc "archive"     :n "a" #'org-archive-subtree
        :desc "add created" :n "e" #'org-expiry-insert-created
        :desc "refile"      :n "r" #'org-refile
        :desc "narrow"      :n "n" #'org-narrow-to-subtree
        :desc "schedule"    :n "s" #'org-schedule
        :desc "widen"       :n "w" #'widen
        :desc "export"      :n "x" #'org-export-dispatch
        :desc "timestamp"   :n "m" #'org-time-stamp
        :desc "set tags"    :n "g" #'org-set-tags-command
        :desc "set prio"    :n "p" #'org-priority))

(def-package! ripgrep)
(def-package! helm-rg)

;; Calc
(after! calc
  (setq calc-algebraic-mode t))

(defun cao/calendar ()
  "Activate (or switch to) `calendar' in its workspace."
  (interactive)
  (if (featurep! :ui workspaces)
      (progn
        (+workspace-switch "Calendar" t)
        (doom/open-scratch-buffer t)
        (+calendar/open-calendar)
        (+workspace/display))
    (setq +calendar--wconf (current-window-configuration))
    (delete-other-windows)
    (doom/open-scratch-buffer t)
    (+calendar/open-calendar)))

;;
;; Bindings
;;

(map! :leader
      (:desc "buffer" :prefix "b"
        :desc "Switch workspace buffer" :n "B" #'persp-switch-to-buffer
        :desc "Switch buffer"           :n "b" #'switch-to-buffer)
      (:desc "file" :prefix "f"
        :desc "Find file"               :n "f" #'find-file
        :desc "rg project"              :n "z" #'helm-projectile-rg
        :desc "Org dir"                 :n "o" (lambda () (interactive) (helm-find-files-1 cao/org-root)))
      (:desc "org" :prefix "o"
        :desc "Capture"    :n "c" #'org-capture
        :desc "Calendar"   :n "C" #'cao/calendar
        :desc "Mail"       :n "m" #'notmuch
        :desc "journal"    :n "j" #'org-journal-new-entry
        :desc "Org dir"    :n "f" (lambda () (interactive) (helm-find-files-1 cao/org-root))
        :desc "Org rifle"  :n "r" #'helm-org-rifle-agenda-files)
      (:desc "window" :prefix "w"
        :desc "vsplit"    :n "/"  #'evil-window-vsplit
        :desc "split"     :n "\\" #'evil-window-split))
