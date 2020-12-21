;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Pete Lawson"
      user-mail-address "geekypete@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/jhu-org/")
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Load and Configure Super Agenda
(use-package org-super-agenda
  :config (org-super-agenda-mode))
(setq org-capture-templates
        '(("t" "Todo" entry (file "~/jhu-org/inbox.org")
        "* TODO %?\n  %U\n  %i\n  %a")
        ("T" "Todo with Clipboard" entry (file "~/jhu-org/inbox.org")
        "* TODO %?\n  %U\n  %x")
        ("a"               ; key
        "Article"         ; name
        entry             ; type
        (file+headline "~/jhu-org/notes.org" "Article")  ; target
        "* %^{Title} %(org-set-tags) :article: \n:PROPERTIES:\n:Created: %U\n:Linked: %a\n:END:\n%i\nBrief description:\n%?"  ; template
        :prepend t        ; properties
        :empty-lines 1    ; properties
        :created t        ; properties
        )
        ("m" "Meeting" entry (file "~/jhu-org/meetings.org")
        "* MEETING: with %?\n" :clock-in t :clock-resume t :empty-lines 1)
        ("n" "Note" entry (file "~/Documents/research/org/research.org")
        "* NOTE %?\n%U" :empty-lines 1)
        ("N" "Note with Clipboard" entry (file "~/jhu-org/todo.org")
        "* NOTE %?\n%U\n   %x" :empty-lines 1)
        ))
(setq org-agenda-custom-commands
      '(("d" "die Tagesordnung"
         (
         ;(agenda "" ((org-agenda-span-start-day "-1d")
                      ;(org-agenda-span 3)
                      ;(org-agenda-start-on-weekday nil)
                      ;(org-agenda-show-all-dates t)
                      ;(org-agenda-use-time-grid t)
                      ;(org-super-agenda-groups
                       ;'((:name "Today"
                                ;:time-grid t
                                ;:scheduled today
                                ;:deadline today
                                ;:order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Next to do"
                                 :todo "NEXT"
                                 :order 1)
                          (:name "File in LibAnswers"
                                 :tag "file"
                                 :order 4)
                          (:name "Important"
                                 :priority "A"
                                 :order 3)
                          (:name "Due Today"
                                 :scheduled today
                                 :deadline today
                                 :todo "today"
                                 :order 2)
                          (:name "Due Soon"
                                 :deadline future
                                 :order 8)
                          (:name "Overdue"
                                 :deadline past
                                 :order 7)
                          (:name "Admin"
                                 :tag "admin"
                                 :order 9)
                          (:name "Consulting"
                                 :tag "consult"
                                 :order 40)
                          (:name "DataVis"
                                 :tag "datavis"
                                 :order 13)
                          (:name "Libguide"
                                 :tag "libguide"
                                 :order 15)
                          (:name "De-Identification"
                                 :tag "deid"
                                 :order 17)
                          (:name "Workshops"
                                 :tag "workshop"
                                 :order 16)
                          (:name "Development"
                                 :tag "dev"
                                 :order 18)
                          (:name "DEIA"
                                 :tag "dei"
                                 :order 19)
                          (:name "ICPSR"
                                 :tag "icpsr"
                                 :order 23)
                          (:name "Social Science Data Group"
                                 :tag "socsci"
                                 :order 23)
                          (:name "To read"
                                 :tag "toread"
                                 :order 30)
                          (:name "Waiting"
                                 :todo "WAITING"
                                 :order 20)
                          (:name "trivial"
                                 :priority<= "C"
                                 :tag ("Trivial" "Unimportant")
                                 :todo ("SOMEDAY" )
                                 :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))
;; Prettify Org Bullets
(add-hook 'org-mode-hook
	            (lambda ()
        (org-superstar-mode 1)))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading externl *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
