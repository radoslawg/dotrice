(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
;;                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

;;(package-refresh-contents)  ;; meh..

;;(unless (package-installed-p 'use-package)
;;  (package-install 'use-package))

(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" "b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
'(package-selected-packages
   (quote
    (abl-mode virtualenvwrapper company-quickhelp material-theme blacken py-autopep8 python-mode company-jedi rainbow-delimiters rainbow-delimeters multiple-cursors projectile omnisharp ox-hugo emojify auto-package-update csharp-mode yasnippet-snippets counsel nyan-mode gruvbox-theme neotree nord-theme nord expand-region hungry-delete popup-kill-ring symon dmenu diminish spaceline spacemacs-theme highlight-symbol jedi flycheck auto-complete magit powershell undo-tree swiper ace-window org zenburn-theme yasnippet which-key use-package try org-bullets helm beacon)))
 '(winner-mode t))
(put 'dired-find-alternate-file 'disabled nil)
