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
(after! org

(use-package org-super-agenda
  :config (org-super-agenda-mode))

;;(setq org-agenda-files (directory-files-recursively "~/jhu-org/" "\\.org$"))

;; Record a CLOSED tag and date/time when moving to completed state (done or cancelled)
(setq org-log-done t)
;; Log closed TODOs with a note and timestamp
(setq org-log-done 'note)
;; Log todo state changes in drawer of todo
(setq org-log-into-drawer t)
;; Set Org Keywords
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w@/!)" "BLOCK(b@/!)" "|" "DONE(d@!)" "CANCELED(c@)")
        (sequence "RESOURCE(r)" "|")
        (sequence "ACTIVE(a)" "|" "INACTIVE(i)")
        ))
;; Set tags
(setq org-tag-alist
      '(
        ("next" . ?n)
        ("queue" . ?p)
        ("forgot" . ?f)
        ("admin" . ?a)
        ("meeting" . ?m)
        ("datavis" . ?v)
        ("access" . ?c)
        ("consult" . ?t)
        ("dev" . ?d)
        ("icpsr" . ?i)
        ("deid" . ?e)
        ("deia" . ?z)
        ("socsci" . ?s)
        ("outreach" . ?o)
        ("workshop" . ?w)
        ("toread" . ?r)
        ("code" . ?x)
        ))
(setq org-capture-templates
        '(("t" "Todo" entry (file "~/jhu-org/inbox.org")
        "* TODO %? %^g\n  %U\n")
        ("T" "Todo with Clipboard" entry (file "~/jhu-org/inbox.org")
        "* TODO %? %^g\n  %U\n  %x")
        ("r" "Resource with Clipboard" entry (file "~/jhu-org/inbox.org")
        "* RESOURCE %?\n  %U\n  %x")
        ("c" "Consultation" entry (file "~/jhu-org/consults.org")
         "* ACTIVE %^{Patron Name}: %^{Short Description of Consult} %t %^g\n** Background\n%x\n** Interactions\n%?\n** TODOs")
        ("a"               ; key
        "Article"         ; name
        entry             ; type
        (file "~/jhu-org/notes.org" "Article")  ; target
        "* %^{Title} %(org-set-tags) :article: \n:PROPERTIES:\n:Created: %U\n:Linked: %a\n:END:\n%i\nBrief description:\n%?"  ; template
        :prepend t        ; properties
        :empty-lines 1    ; properties
        :created t        ; properties
        )
        ("p" "Project" entry (file "~/jhu-org/projects.org")
        "* TODO %^{Project Name} [/] %^g \n:PROPERTIES:\n:Description: %^{Brief Description}\n:Created: %U\n:ARCHIVE: %s_archive::* %\\1\n:COOKIE_DATA: todo recursive\n:END:\n%?")
        ("m" "Meeting" entry (file "~/jhu-org/meetings.org")
        "* %^{Meeting Title} %^T\n:PROPERTIES:\n:Description: %^{Brief Description of Meeting}\n** Background\n** Meeting Notes\n%?")
        ("M" "Meeting with Clipboard" entry (file "~/jhu-org/meetings.org")
        "* %^{Meeting Title} %^T\n:PROPERTIES:\n:Description: %^{Brief Description of Meeting}\n** Background\n%x\n** Meeting Notes\n%?")
        ("n" "Note" entry (file "~/Documents/jhu-org/inbox.org")
        "* NOTE %?\n%U" :empty-lines 1)
        ("N" "Note with Clipboard" entry (file "~/jhu-org/todo.org")
        "* NOTE %?\n%U\n   %x" :empty-lines 1)
        ))
(setq org-agenda-custom-commands
      '(
        ("e" "Exclusively TODOs"
         ((todo "TODO"
                ((org-agenda-overriding-header "TODO")
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "INACTIVE" "ACTIVE" "CANCELED" "RESOURCE")))
                 )))
         )
        ("r" "Monthly review"
         (
          (tags "consult" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("TODO" "WAIT")))))
          (tags "next" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "INACTIVE" "ACTIVE" "CANCELED")))
                        (org-tags-match-list-sublevels 'nil)))
          (agenda "" ((org-agenda-span 'month)
                      (org-agenda-todo-list-sublevels 'indented)
                      (org-agenda-entry-types '(:deadline :scheduled))
          ))
         ))
        ("w" "Weekly review"
                agenda ""
                ((org-agenda-start-day "-7d")
                (org-agenda-span 8)
                (org-agenda-start-on-weekday 3)
                (org-agenda-start-with-log-mode '(closed))
                (org-agenda-archives-mode t)
                (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo '("DONE" "INACTIVE")))
                ))
        ("p" "Projects"
         ((todo "TODO" (
                       (org-agenda-files '("~/jhu-org/projects.org"))
                       (org-super-agenda-groups
                        '((:auto-parent t
                          )))))
          )
         )
          ;; '((:auto-category t))))

        ("d" "My Agenda"
         (
          (agenda "" ((org-agenda-span 10)
                      (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "INACTIVE" "ACTIVE" "CANCELED" "RESOURCE")))
                     ; (org-agenda-entry-types '(:date :deadline :scheduled))
                      ))
          (alltodo "" ((org-agenda-overriding-header "")
                      (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "INACTIVE" "ACTIVE" "CANCELED" "RESOURCE")))
                       (org-super-agenda-groups
                        '(
                          (:discard (:todo "RESOURCE"))
                          (:name "Today's TODOs"
                                 :tag "next"
                                 :order 1)
                          (:name "Consulting"
                                 :tag "consult"
                                 :order 2)
                          (:name "Due Today"
                                 :scheduled today
                                 :deadline today
                                 :todo "today"
                                 :order 3)
                          (:name "Overdue"
                                 :deadline past
                                 :order 7)
                          (:name "Important"
                                 :priority "A"
                                 :order 4)
                          (:name "Admin"
                                 :tag "admin"
                                 :order 10)
                          (:name "File in LibAnswers"
                                 :tag "file"
                                 :order 15)
                          (:name "Outreach"
                                 :tag "outreach"
                                 :order 20)
                          (:name "The Forgotten Realm"
                                 :tag "forgot"
                                 :order 25)
                          (:name "Data Access and Discovery"
                                 :tag "access"
                                 :order 30)
                          (:name "DataVis"
                                 :tag "datavis"
                                 :order 50)
                          (:name "Libguide"
                                 :tag "libguide"
                                 :order 55)
                          (:name "Workshops"
                                 :tag "workshop"
                                 :order 60)
                          (:name "De-Identification"
                                 :tag "deid"
                                 :order 65)
                          (:name "Development"
                                 :tag "dev"
                                 :order 70)
                          (:name "DEIA"
                                 :tag "deia"
                                 :order 75)
                          (:name "Waiting"
                                 :todo "WAITING"
                                 :order 80)
                          (:name "ICPSR"
                                 :tag "icpsr"
                                 :order 85)
                          (:name "Social Science Data Group"
                                 :tag "socsci"
                                 :order 90)
                          (:name "Coding Working Group"
                                 :tag "code"
                                 :order 95)
                          (:name "To read"
                                 :tag "toread"
                                 :order 100)
                          (:name "trivial"
                                 :priority<= "C"
                                 :tag ("Trivial" "Unimportant")
                                 :todo ("SOMEDAY" )
                                 :order 110)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))
)

;; Add VIM movement to Agenda
;(define-key org-agenda-mode-map "J" 'evil-next-line)
;(define-key org-agenda-mode-map "K" 'evil-previous-line)

;; Prettify Org Bullets
(add-hook 'org-mode-hook
	            (lambda ()
        (org-superstar-mode 1)))

;; Add Org-Pomodoro bindings

 (map!
 (:after org
  (:map org-mode-map "C-c o" #'org-pomodoro))
 (:after org-agenda
   (:map org-agenda-mode-map "C-c o" #'org-pomodoro)))

;; Add Treemacs binding to toggle Treemacs
(map! :leader
      :desc "Treemacs"
      "t t" #'treemacs)

;; Add org sort binding to toggle org
(map! :leader
      :desc "Sort Org Entries"
      "m j" #'org-sort-entries)

 ;;(map!
 ;;(:after org
 ;; (:map org-mode-map "C-c d" #'org-demote-subtree)
 ;; (:map org-mode-map "C-c p" #'org-promote-subtree)
 ;; ))

;; Org-Journal config
(setq  org-journal-enable-agenda-integration t
       org-journal-file-type 'weekly
       ;; org-journal-date-format "%A, %Y-%m-%d"
       ;; org-journal-file-format "%Y-%m-%d.org"
       ;; org-journal-date-prefix "#+TITLE: "
       )

;; Org journal directory
;;
;; Promote org heading
(map! :leader
      (:prefix ("v" . "org-mode")
      :desc "Promote Org Heading"
      "k" #'org-do-promote))

;; Promote org heading
(map! :leader
      (:prefix ("v" . "org-mode")
      :desc "Demote Org Heading"
      "j" #'org-do-demote))


 (setq-default sysTypeSpecific  system-type) ;; get the system-type value

 (cond
  ;; If type is "gnu/linux", override to "wsl/linux" if it's WSL.
  ((eq sysTypeSpecific 'gnu/linux)
   (when (string-match "Linux.*Microsoft.*Linux"
                       (shell-command-to-string "uname -a"))

     (setq-default sysTypeSpecific "wsl/linux") ;; for later use.
     (setq
      cmdExeBin"/mnt/c/Windows/System32/cmd.exe"
      cmdExeArgs '("/c" "start" "") )
     (setq
      browse-url-generic-program  cmdExeBin
      browse-url-generic-args     cmdExeArgs
      browse-url-browser-function 'browse-url-generic)
     )))

 ;; Determine the specific system type. 
 ;; Emacs variable system-type doesn't yet have a "wsl/linux" value,
; (setq-default sysTypeSpecific  system-type) ;; get the system-type value

;; Launch browser in Windows
;(when (getenv "WSLENV")
;  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
;	(cmd-args '("/c" "start")))
;    (when (file-exists-p cmd-exe)
;      (setq browse-url-generic-program  cmd-exe
;	    browse-url-generic-args     cmd-args
;	    browse-url-browser-function 'browse-url-generic
;	    search-web-default-browser 'browse-url-generic))))


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
