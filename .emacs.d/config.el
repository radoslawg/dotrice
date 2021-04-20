;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 100 1000 1000))

(defun rg/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                     (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'rg/display-startup-time)

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
      (package-refresh-contents)
      (package-install 'use-package))
    (setq use-package-always-ensure t)
;;    (setq use-package-verbose t)

(use-package auto-package-update
  :ensure t
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-delete-old-versions t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  )

(use-package try
  :commands try)

(setq visible-bell t)

(setq delete-active-region nil)
(define-key global-map [C-tab] 'indent-region)

;; make PC keyboard's Win key or other to type Super or Hyper, for emacs running on Windows.
(setq w32-pass-lwindow-to-system nil)
(setq w32-lwindow-modifier 'super) ; Left Windows key

(setq w32-pass-rwindow-to-system nil)
(setq w32-rwindow-modifier 'super) ; Right Windows key

(setq w32-pass-apps-to-system nil)
(setq w32-apps-modifier 'hyper) ; Menu/App key

(setq initial-buffer-choice (lambda () (get-buffer-create "*scratch*")))
  (server-force-delete)
(require 'server)
(unless (server-running-p)
  (cond
   ((eq system-type 'windows-nt)
    (setq server-auth-dir "~\\.emacs.d\\server\\"))
   ((eq system-type 'gnu/linux)
    (setq server-auth-dir "~/.emacs.d/server/")))
  (setq server-name "emacs-server-file")
  (server-start))
  (global-set-key (kbd "C-x C-c") 'save-buffers-kill-emacs)

(setq-default buffer-file-coding-system 'utf-8-auto)
(setq buffer-file-coding-system 'utf-8-auto)
(setq default-buffer-file-coding-system 'utf-8-auto)
(set-language-environment 'polish)
(set-default-coding-systems 'utf-8-auto)
(prefer-coding-system 'utf-8-auto)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-message t)

(defalias 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode)

(winner-mode 1)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-aghol --group-directories-first")
           (ls-lisp-use-insert-directory-program nil)
           (ls-lisp-dirs-first t))
  )

(setq dired-dwim-target t)

(add-to-list 'load-path "~/.emacs.d/lisp/dired+")
(require 'dired+)

(use-package dired-single
  :after dired
  :bind (
  :map dired-mode-map
  ([remap dired-find-file] . dired-single-buffer)
  ([remap dired-mouse-find-file-other-window] . dired-single-buffer-mouse)
  ([remap dired-up-directory] . dired-single-up-directory)
  )
)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(setq
   backup-by-copying t
   backup-directory-alist
    '(("." . "~/.emacs-saves/"))
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)

;;(windmove-default-keybindings)
(global-set-key (kbd "M-s-<left>")  'windmove-left)
(global-set-key (kbd "M-s-<right>") 'windmove-right)
(global-set-key (kbd "M-s-<up>")    'windmove-up)
(global-set-key (kbd "M-s-<down>")  'windmove-down)
;; Make windmove work in org-mode:
;;(add-hook 'org-shiftup-final-hook 'windmove-up)
;;(add-hook 'org-shiftleft-final-hook 'windmove-left)
;;(add-hook 'org-shiftdown-final-hook 'windmove-down)
;;(add-hook 'org-shiftright-final-hook 'windmove-right)

(display-time)

(advice-add 'bat-run :override
            (lambda () 
              (interactive)
              (save-buffer)
              (async-shell-command buffer-file-name))
            )

(defun copy-line (arg)
      "Copy lines (as many as prefix argument) in the kill ring.
        Ease of use features: - Move to start of next line.  -
        Appends the copy on sequential calls.  - Use newline as
        last char even on the last line of the buffer.  - If region
        is active, copy its lines."
      (interactive "p")
      (let ((beg (line-beginning-position))
            (end (line-end-position arg)))
        (when mark-active
          (if (> (point) (mark))
              (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
            (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
        (if (eq last-command 'copy-line)
            (kill-append (buffer-substring beg end) (< end beg))
          (kill-ring-save beg end)))
      (kill-append "\n" nil)
      (beginning-of-line (or (and arg (1+ arg)) 2))
      (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))

(global-set-key "\C-c\C-k" 'copy-line)

(defun insert-line-below ()
  (interactive)
  (move-end-of-line nil)
  (open-line 1)
  (next-line))

(defun insert-line-above ()
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (indent-according-to-mode)
  (previous-line))

(global-set-key (kbd "M-n") 'insert-line-below)
(global-set-key (kbd "M-p") 'insert-line-above)

(defun config-visit()
  (interactive)
  (find-file "~/.emacs.d/config.org"))

(defun config-reload()
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))

(defun geosoft-forward-word ()
   ;; Move one word forward. Leave the pointer at start of word
   ;; instead of emacs default end of word. Treat _ as part of word
   (interactive)
   (forward-char 1)
   (backward-word 1)
   (forward-word 2)
   (backward-word 1)
   (backward-char 1)
   (cond ((looking-at "_") (forward-char 1) (geosoft-forward-word))
	 (t (forward-char 1))))

(defun geosoft-backward-word ()
   ;; Move one word backward. Leave the pointer at start of word
   ;; Treat _ as part of word
   (interactive)
   (backward-word 1)
   (backward-char 1)
   (cond ((looking-at "_") (geosoft-backward-word))
	 (t (forward-char 1))))

(global-set-key (kbd "M-f") 'geosoft-forward-word)
(global-set-key (kbd "M-b") 'geosoft-backward-word)

(defun split-and-follow-window-horizontally()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))

(defun split-and-follow-window-vertically()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

(defun radekg-kill-line()
  (interactive)
  (kill-line)
  (fixup-whitespace))

(defun radekg-join-line()
  (interactive)
  (save-excursion
    (join-line 1)
    )
  )

(defun kill-curr-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-c C-.")
                (lambda()
                  (interactive)
                  (setq current-prefix-arg '(16))
                  (call-interactively 'org-time-stamp-inactive)))

(setq inhibit-compacting-font-caches 't)

;; (use-package zenburn-theme
;;   :ensure t
;;   :init
;;   (load-theme 'zenburn t)
;;   )
;; ;;(use-package monokai-theme
;;  :ensure t
;;  :init
;;  (load-theme 'monokai t nil)
;;  )
;; (use-package material-theme
;; :ensure t)
;;        (use-package gruber-darker-theme
;;          :ensure t
;;          )
;;        (load-theme 'gruber-darker t)
;;(load-theme 'wombat t)
(use-package doom-themes
  :init (load-theme 'doom-snazzy t)
  )

(add-to-list 'default-frame-alist '(alpha . (93 . 85)))
(set-frame-parameter nil 'alpha '(93 . 85))

(set-face-attribute 'default nil
                    :font "Iosevka"
                    :weight 'normal
                    :width 'normal
                    :height 115)
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 130 :weight 'regular)
(set-face-attribute 'fixed-pitch nil :font "Iosevka" :weight 'normal)

(global-hl-line-mode t)
(global-prettify-symbols-mode t)

(when window-system (set-frame-size (selected-frame) 200 50))
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 200))

(setq-default fill-column '120)

(use-package emojify
  :config (setq emojify-display-style 'image)
          (setq emojify-emoji-set "emojione-v2.2.6-22")
  :init (global-emojify-mode 1)
  :bind ("C-. ." . emojify-insert-emoji)

  :ensure t
  )
(global-set-key (kbd "C-. <right>") '(lambda()(interactive)(insert "➡")))
(global-set-key (kbd "C-. <left>") '(lambda()(interactive)(insert "⬅")))
(global-set-key (kbd "C-. <up>") '(lambda()(interactive)(insert "⬆")))
(global-set-key (kbd "C-. <down>") '(lambda()(interactive)(insert "⬇")))

;; Make whitespace-mode with very basic background coloring for whitespaces.
;; http://ergoemacs.org/emacs/whitespace-mode.html
(setq whitespace-style (quote (face spaces space-mark tabs tab-mark space-after-tab space-before-tab empty trailing)))

(setq whitespace-display-mappings
      '(
        (space-mark 32 [183] [46])
        (newline-mark 10 [182 10])
        (tab-mark 9 [9655 9] [92 9])
        ))

(add-hook 'prog-mode-hook 'whitespace-mode)
(whitespace-mode 1)
(set-face-attribute 'whitespace-space nil :foreground "gray20")
(whitespace-mode 0)

(use-package org
:defer 0)

(defun rg/org-capture ()
  (interactive)
  (raise-frame)
  (select-frame-set-input-focus (selected-frame))
  (org-capture)
  )

(setq org-log-into-drawer t)

(add-hook 'org-mode-hook (lambda()
                           (org-indent-mode 1)
                           (variable-pitch-mode 1)
                           (visual-line-mode 1)
                           ))
(setq org-image-actual-width nil)
(setq org-hide-leading-stars 't)
(setq org-directory "~/MojePliki/org/")
(setq org-agenda-skip-unavailable-files t)
(setq org-agenda-start-on-weekday nil)
(setq org-tags-column 99)
(setq org-ellipsis " ▼") ;; ... na końcu nagłówków na trójkąt
(setq org-hide-emphasis-markers t) ;; ukryj znaki formuatujące
(font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "\u2022"))))))
(require 'org-tempo) ;; potrzebne aby Bloki src wstawiać automatem '<s'
(add-to-list 'org-structure-template-alist '("se" . "src emacs-lisp"))

(setq org-todo-keywords '((sequence "TODO(t!)" ":eyes: ROZPOCZĘTE(r)" "|" ":checkered_flag: ZAKOŃCZONE(z!)" ))
       org-todo-keyword-faces 
       '(
         ("TODO" :foreground "#ff6c85" :weight bold :underline t)
         ("NASTĘPNE" :foreground "#5f5efe" :weight normal :underline t)
         (":eyes: ROZPOCZĘTE" :foreground "#0098dd" :weight bold :underline t)
         ("OCZEKUJE" :foreground "#9f7efe" :weight normal :underline t)
         ("WSTRZYMANE" :foreground "#707070" :weight normal :underline t)
         ("KIEDYŚ" :foreground "#80A080" :weight normal :underline t)
         (":checkered_flag: ZAKOŃCZONE" :foreground "#60c15f" :weight normal :underline t)
         ("ANULOWANE" :foreground "#40913f" :weight normal :underline t))
)

(setq org-agenda-todo-ignore-with-date nil)

(setq european-calendar-style t)
(setq calendar-week-start-day 1)

;;\22B9 \22C2 ? \u233 ? ? \u2234  ?
   (use-package org-bullets
     :hook (org-mode-hook . org-bullets-mode)
     :config
     (setq org-bullets-bullet-list '("\u2836")) ;; eweuntualnie 2894
     )

(setq org-return-follows-link 't)

;; (setq org-blank-before-new-entry
;;       '((heading . nil) (plain-list-item . nil)))

(setq org-special-ctrl-a/e t)

(add-hook 'after-init-hook
	  (lambda ()
	    (run-with-timer 300 300 'org-save-all-org-buffers)))

(setq org-capture-templates
      '(
   ;; TODO     (t) Todo template
   ("t" "ToDo" entry (file "refile.org")
    "* TODO %?
  :LOGBOOK:
  - State \"TODO\"       from \"\"           %U
  :END:" :empty-lines 1)
   ("n" "Notatka" entry (file "refile.org")
    "* %? %U" :empty-lines 1)
   ("r" "RPG" entry (file "refile.org")
    "* %? %U :rpg:" :empty-lines 1)
   ("j" "Journal" entry (file+datetree "journal.org")
    "* %? %U" :empty-lines 1)
   ("l" "Cliplink" entry (file "refile.org")
    "* TODO %(org-cliplink-capture)
  :LOGBOOK:
  - State \"TODO\"       from \"\"           %U
  :END:
  %?" :empty-lines 1)
   )
      )

(setq org-refile-targets (quote (("organizator.org" :maxlevel . 3)
                                 ("notatki.org" :maxlevel . 2)
                                 )))
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-use-outline-path t)
(setq org-log-refile 'time)

;;    (setq org-agenda-files (list org-directory) )
(setq org-agenda-files '("organizator.org" "refile.org" "dates.org" "journal.org"))

(setq org-agenda-todo-ignore-scheduled (quote future))

(setq org-agenda-todo-ignore-deadlines (quote far))

(setq org-agenda-skip-scheduled-if-done t)

(use-package org-cliplink
  :commands org-cliplink
  :bind ("C-c c l" . org-cliplink)
  )

(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)
                (org-level-6 . 1.1)))
  (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

(set-face-attribute 'org-block nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-table nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-link nil :inherit '(link fixed-pitch))
;;  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

(defun rg/org-mode-visual-fill ()
    (setq visual-fill-column-width 140
          visual-fill-column-center-text t)
    (visual-fill-column-mode 1))

  (use-package visual-fill-column
    :hook (org-mode . rg/org-mode-visual-fill)
)

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key)
  )

(use-package ivy
   :diminish
   :config
   (ivy-mode 1)
   (setq ivy-use-virtual-buffers t)
   (setq ivy-count-format "(%d/%d) ")
   )

(use-package all-the-icons-ivy-rich
  :after ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1)
  )

(use-package all-the-icons-ivy
  :after ivy
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

;; (use-package posframe
;;   :ensure t
;;   )

;; (use-package helm-posframe
;;   :ensure t
;;   :config
;;   (helm-posframe-enable)
;;   (setq helm-posframe-parameters
;;     '((left-fringe . 10)
;;       (right-fringe . 10)))
;;   )

;; (use-package ivy-posframe
;;   :ensure t
;;   :config
;;   (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
;;   (ivy-posframe-mode 1)
;;   )

;; (use-package company-posframe
;;   :ensure t
;;   :config
;;   (company-posframe-mode 1)
;;   )

(use-package counsel
  :after ivy
  :bind (
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-variable] . counsel-describe-variable)
  ("M-x" . counsel-M-x)
  ("M-y" . counsel-yank-pop)
  ("C-x C-f" . counsel-find-file)
  ("C-h l" . counsel-find-library)
  ("C-h S" . counsel-info-lookup-symbol)
  ("C-x b" . counsel-switch-buffer)
  ("C-x C-b" . counsel-switch-buffer-other-window)
  ("<f2> u" . counsel-unicode-char)
  :map ivy-minibuffer-map
  ("M-y" . ivy-next-line)
  :map minibuffer-local-map
  ("C-r" . 'counsel-minibuffer-history)
  )
)

;;   (use-package helm
;;     :ensure t
;;     :init (helm-mode 1)
;;     :config
;;     (setq helm-boring-buffer-regexp-list (list (rx "*magit-") (rx "*helm")))
;;     :bind
;;     ("M-x" . helm-M-x)
;;     ("C-x C-b" . helm-buffers-list)
;;     ("C-x C-f" . helm-find-files)
;;     ("C-x r b" . helm-bookmarks)
;; )

;; (define-key helm-find-files-map "\t" 'helm-execute-persistent-action)

(use-package which-key
  :defer 0
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3)
  )

(use-package company
   :diminish (company-mode . " @")
   :hook (after-init . global-company-mode)
   :config
   (add-to-list 'company-backends 'company-omnisharp)
   (add-to-list 'company-backends 'company-jedi)
   (setq company-idle-delay 1
         company-require-match nil)
   :bind
   ("M-<SPC>" . company-complete)
   (:map company-active-map
         ("C-n" . company-select-next-or-abort)
         ("C-p" . company-select-previous-or-abort))
   )

(use-package company-quickhelp
   :after company
   :init (with-eval-after-load 'company
           (company-quickhelp-mode)))

(use-package yasnippet
:config
 (yas-global-mode 1)
  )

(use-package yasnippet-snippets
:after yasnippet
  )

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "->") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

(use-package beacon
  :config
  (beacon-mode 1)
  )

(use-package ace-window
  :commands ace-window
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    )
  )

(use-package swiper
  :bind
  ("C-s" . swiper)
  )

(use-package undo-tree
  :init
  (global-undo-tree-mode))

(use-package powershell
  :mode (("\\.ps1\\'" . powershell-mode))
  )

(use-package magit
  :commands magit-status)

(use-package avy
  :commands (avy-goto-char-timer avy-goto-line avy-goto-char)
  :bind ("M-s" . avy-goto-char-timer)
  ("M-l" . avy-goto-line)
  ("M-S" . avy-goto-char))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

(use-package highlight-symbol
  :commands (highlight-symbol highlight-symbol-next highlight-symbol-prev highlight-symbol-query-replace)
  :init
  (highlight-symbol-mode 1)
  :bind ([C-f3] . highlight-symbol)
  ("C-*" . highlight-symbol-next)
  ("C-#" . highlight-symbol-prev)
  ("C-M-*" . highlight-symbol-query-replace)
  )

;; (use-package auto-complete
;;   :ensure t
;;   :init
;;   (progn
;;     (require 'auto-complete-config)
;;     (ac-config-default)
;;     (global-auto-complete-mode t)
;;     ))

(use-package diminish
  :ensure t
  :init
  (diminish 'helm-mode)
  (diminish 'undo-tree-mode)
  (diminish 'which-key-mode)
  (diminish 'auto-fill-mode)
  )

(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package neotree
  :commands neotree-toggle
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-smart-open t)
  :bind
  ([f8] . neotree-toggle))

(use-package nyan-mode
  :ensure t
  :init
  (nyan-mode 1))

(use-package ox-hugo
  :ensure t
  :after ox
  )

(use-package projectile
    :ensure t
    :init
    (projectile-mode +1)
    :bind-keymap
    ("H-p" . projectile-command-map)
)

(use-package omnisharp
    :after csharp-mode
    :init
    (add-hook 'csharp-mode-hook 'omnisharp-mode)
    (add-hook 'csharp-mode-hook 'company-mode)
    (add-hook 'csharp-mode-hook 'flycheck-mode)
    (add-hook 'csharp-mode-hook 'projectile-mode)
    :bind
    ("C-`" . omnisharp-run-code-action-refactoring)
    ([f5] . recompile)
)

(use-package csharp-mode
  :mode (("\\.cs\\'" . sharp-mode))
  )

(use-package multiple-cursors
  :bind
  ("C-S-c C-S-c" . 'mc/edit-lines)
  ("C->" . 'mc/mark-next-like-this)
  ("C-<" . 'mc/mark-previous-like-this)
  ("C-c c <" . 'mc/mark-all-like-this)
  ("C-\"" . 'mc/skip-to-next-like-this)
  ("C-:" . 'mc/skip-to-previous-like-this)
  ("C-S-<mouse-1>" . mc/add-cursor-on-click)
)

(use-package rainbow-delimiters
  :commands rainbow-delimiters-mode
  :hook (prog-mode . rainbow-delimiters-mode)
)

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 30)
  (setq doom-modeline-major-mode-color-icon t)

  ;; How wide the mode-line bar should be. It's only respected in GUI.
  (setq doom-modeline-bar-width 10)
  ;; Whether display the icon for the buffer state. It respects `doom-modeline-icon'.
  (setq doom-modeline-buffer-state-icon t)
  ;; Determines the style used by `doom-modeline-buffer-file-name'.
  ;;
  ;; Given ~/Projects/FOSS/emacs/lisp/comint.el
  ;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
  ;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
  ;;   truncate-with-project => emacs/l/comint.el
  ;;   truncate-except-project => ~/P/F/emacs/l/comint.el
  ;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
  ;;   truncate-all => ~/P/F/e/l/comint.el
  ;;   relative-from-project => emacs/lisp/comint.el
  ;;   relative-to-project => lisp/comint.el
  ;;   file-name => comint.el
  ;;   buffer-name => comint.el<2> (uniquify buffer name)
  ;;
  ;; If you are expereicing the laggy issue, especially while editing remote files
  ;; with tramp, please try `file-name' style.
  ;; Please refer to https://github.com/bbatsov/projectile/issues/657.
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)

  ;; Whether display the modification icon for the buffer.
  ;; It respects `doom-modeline-icon' and `doom-modeline-buffer-state-icon'.
  (setq doom-modeline-buffer-modification-icon t)

  ;; Whether ;TODO: o use unicode as a fallback (instead of ASCII) when not using icons.
  (setq doom-modeline-unicode-fallback t)

  ;; Whether display minor modes in mode-line.
  (setq doom-modeline-minor-modes (featurep 'minions))
  ;; Whether display buffer encoding.
  (setq doom-modeline-buffer-encoding t)


  ;; The maximum displayed length of the branch name of version control.
  (setq doom-modeline-vcs-max-length 12)

  ;; Whether display environment version.
  (setq doom-modeline-env-version t)

  (setq doom-modeline-vcs-max-length 50)
  )

(use-package flymake
  :hook (prog-mode . flymake-mode))

(use-package iedit
  :ensure t)

(use-package ahk-mode
:mode (("\\.ahk\\'" . ahk-mode))
  )

(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(add-hook 'python-mode-hook (lambda () (setq auto-fill-function 'do-auto-fill) (setq fill-column 79)))
(add-hook 'python-mode-hook (lambda () (hs-minor-mode 1)))
(bind-keys :map prog-mode-map
           ("<C-S-tab>" . hs-toggle-hiding))

(use-package jedi
    :hook (python-mode-hook . jedi:setup)
    (python-mode-hook . jedi:ac-setup)
)

  (use-package company-jedi
    :after (jedi company))

(use-package elpy
    :hook (python-mode-hook . elpy-enable)
    :custom
    (python-indent-offset 4)
)

;; (use-package pyvenv
  ;; :ensure t
  ;; :init
  ;; (pyvenv-mode 1)
  ;; (pyvenv-tracking-mode 1))

(use-package py-autopep8
    :hook (elpy-mode-hook . 'py-autopep8-enable-on-save)
)

;;  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)

(global-set-key (kbd "C-S-k") 'kill-whole-line)
(global-set-key (kbd "C-M-S-k") 'copy-line)
(global-set-key (kbd "C-c c e") 'config-visit)
(global-set-key (kbd "C-c c r") 'config-reload)
(global-set-key (kbd "C-c c o") '(lambda()(interactive)(find-file "~/MojePliki/org/organizator.org")))
(global-set-key (kbd "C-c c n") '(lambda()(interactive)(find-file "~/MojePliki/org/notatki.org")))
(global-set-key (kbd "C-c c w") '(lambda()(interactive)(find-file "~/MojePliki/org/refile.org")))
(global-set-key (kbd "C-c c j") '(lambda()(interactive)(find-file "~/MojePliki/org/journal.org")))
(global-set-key (kbd "C-S-r") 'revert-buffer)
(global-set-key [remap split-window-below] 'split-and-follow-window-horizontally)
(global-set-key [remap split-window-right] 'split-and-follow-window-vertically)
(global-set-key [remap kill-line] 'radekg-kill-line)
(global-set-key (kbd "C-M-k") 'radekg-join-line) 
(global-set-key [remap kill-buffer] 'kill-curr-buffer)

(define-key org-mode-map (kbd "C-M-b") 'org-mark-ring-goto)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key (kbd "<f6>") 'org-capture)

(defun unit/build ()
  "Buduje i uruchamia unit-a"
  (interactive)
  (async-shell-command
   ;; command and parameters
   "c:/work/unit.git/Lib/nant/bin/NAnt.exe -buildfile:c:/work/unit.git/Script/lodz.build build_server_sln build_client deploy_server deploy_client"
   ;; output buffer
   "*Unit-build*"
   ;; name of the error buffer
   nil
   )
  )

(global-set-key [f9] 'unit/build)

(defun rg/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/config.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle)))
  )

  (add-hook 'org-mode-hook (lambda() (add-hook 'after-save-hook #'rg/org-babel-tangle-config)))
