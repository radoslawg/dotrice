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
 '(elfeed-feeds
   (quote
    ("http://www.kicktraq.com/categories/games/tabletop%20games/latest.rss")))
 '(org-agenda-files (quote ("~/org/praca.org" "~/org/osobiste.org")))
 '(package-selected-packages
   (quote
    (monokai-theme atom-dark-theme dark-atom-theme gruvbox-theme neotree nord-theme nord expand-region hungry-delete popup-kill-ring symon dmenu diminish spaceline spacemacs-theme highlight-symbol jedi flycheck auto-complete magit powershell undo-tree swiper ace-window org zenburn-theme yasnippet which-key use-package try org-bullets helm beacon)))
 '(winner-mode t))
