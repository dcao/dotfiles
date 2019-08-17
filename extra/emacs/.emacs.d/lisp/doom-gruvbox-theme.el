;;; doom-gruvbox-theme.el
(require 'doom-themes)

;;
(defgroup doom-gruvbox-theme nil
  "Options for doom-themes"
  :group 'doom-themes)

(defcustom doom-gruvbox-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-gruvbox-theme
  :type 'boolean)

(defcustom doom-gruvbox-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-gruvbox-theme
  :type 'boolean)

(defcustom doom-gruvbox-comment-bg doom-gruvbox-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-gruvbox-theme
  :type 'boolean)

(defcustom doom-gruvbox-padded-modeline nil
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-gruvbox-theme
  :type '(or integer boolean))

;;
(def-doom-theme doom-gruvbox
  "Doom gruvbox theme"

  ;; name        default   256       16
  ((bg         '("#282828" nil       nil            ))
   (bg-alt     '("#3E3E3E" nil       nil            ))
   (base0      '("#1A150C" "#121212" "black"        ))
   (base1      '("#342A17" "#262626" "brightblack"  ))
   (base2      '("#4E3F23" "#3A3A3A" "brightblack"  ))
   (base3      '("#67542E" "#4E4E4E" "brightblack"  ))
   (base4      '("#81693A" "#875F5F" "brightblack"  ))
   (base5      '("#9B7F45" "#AF875F" "brightblack"  ))
   (base6      '("#B29353" "#AF875F" "brightblack"  ))
   (base7      '("#BEA36D" "#AFAF5F" "brightblack"  ))
   (base8      '("#C9B387" "#D7AF87" "white"        ))
   (fg-alt     '("#DDD0B4" "#D7D7AF" "brightwhite"  ))
   (fg         '("#D5C4A1" "#D7D7AF" "white"        ))

   (grey       base4)
   (red        '("#FB4934" "#FF5F5F" "red"          ))
   (orange     '("#FB8332" "#FF875F" "brightred"    ))
   (green      '("#94961E" "#878700" "green"        ))
   (teal       '("#B8BB26" "#AFAF00" "brightgreen"  ))
   (yellow     '("#FABD2F" "#FFAF00" "yellow"       ))
   (blue       '("#83A598" "#87AF87" "brightblue"   ))
   (dark-blue  '("#64897B" "#5F8787" "blue"         ))
   (magenta    '("#C15371" "#AF5F5F" "magenta"      ))
   (violet     '("#D3869B" "#D78787" "brightmagenta"))
   (cyan       '("#8EC07C" "#87AF87" "brightcyan"   ))
   (dark-cyan  '("#6AAB52" "#5FAF5F" "cyan"         ))

   ;; face categories -- required for all themes
   (highlight      blue)
   (vertical-bar   (doom-lighten bg 0.05))
   (selection      dark-blue)
   (builtin        blue)
   (comments       (if doom-gruvbox-brighter-comments dark-cyan base5))
   (doc-comments   (doom-lighten (if doom-gruvbox-brighter-comments dark-cyan base5) 0.25))
   (constants      red)
   (functions      yellow)
   (keywords       blue)
   (methods        cyan)
   (operators      blue)
   (type           yellow)
   (strings        teal)
   (variables      cyan)
   (numbers        magenta)
   (region         dark-blue)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (-modeline-bright doom-gruvbox-brighter-modeline)
   (-modeline-pad
    (when doom-gruvbox-padded-modeline
      (if (integerp doom-gruvbox-padded-modeline) doom-gruvbox-padded-modeline 4)))

   (modeline-fg     nil)
   (modeline-fg-alt base5)

   (modeline-bg
    (if -modeline-bright
        base3
        `(,(doom-darken (car bg) 0.15) ,@(cdr base0))))
   (modeline-bg-l
    (if -modeline-bright
        base3
        `(,(doom-darken (car bg) 0.1) ,@(cdr base0))))
   (modeline-bg-inactive   (doom-darken bg 0.1))
   (modeline-bg-inactive-l `(,(car bg) ,@(cdr base1))))


  ;; --- extra faces ------------------------
  ((elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")

   ((line-number &override) :foreground fg-alt)
   ((line-number-current-line &override) :foreground fg)
   ((line-number &override) :background (doom-darken bg 0.025))

   (font-lock-comment-face
    :foreground comments
    :background (if doom-gruvbox-comment-bg (doom-lighten bg 0.05)))
   (font-lock-doc-face
    :inherit 'font-lock-comment-face
    :foreground doc-comments)

   (doom-modeline-bar :background (if -modeline-bright modeline-bg highlight))

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis
    :foreground (if -modeline-bright base8 highlight))
   (mode-line-buffer-id
    :foreground highlight)

   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))

   (telephone-line-accent-active
    :inherit 'mode-line
    :background (doom-lighten bg 0.2))
   (telephone-line-accent-inactive
    :inherit 'mode-line
    :background (doom-lighten bg 0.05))

   ;; --- major-mode faces -------------------
   ;; css-mode / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)

   ;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   (markdown-code-face :background (doom-lighten base3 0.05))

   ;; org-mode
   (org-hide :foreground hidden)
   (org-block :background base2)
   (org-block-begin-line :background base2 :foreground comments)
   (solaire-org-hide-face :foreground hidden))


  ;; --- extra variables ---------------------
  ;; ()
  )

;;; doom-gruvbox-theme.el ends here