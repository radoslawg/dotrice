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

;; Handle of server thingy
(server-force-delete)
(server-start)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a622aaf6377fe1cd14e4298497b7b2cae2efc9e0ce362dade3a58c16c89e089c" "e2fd81495089dc09d14a88f29dfdff7645f213e2c03650ac2dd275de52a513de" "2a9039b093df61e4517302f40ebaf2d3e95215cb2f9684c8c1a446659ee226b9" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "565aa482e486e2bdb9c3cf5bfb14d1a07c4a42cfc0dc9d6a14069e53b6435b56" "9fcac3986e3550baac55dc6175195a4c7537e8aa082043dcbe3f93f548a3a1e0" "242527ce24b140d304381952aa7a081179a9848d734446d913ca8ef0af3cef21" "44247f2a14c661d96d2bff302f1dbf37ebe7616935e4682102b68c0b6cc80095" "bf390ecb203806cbe351b966a88fc3036f3ff68cd2547db6ee3676e87327b311" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "e11569fd7e31321a33358ee4b232c2d3cf05caccd90f896e1df6cab228191109" "a914fce8ef585e826ea136da5478bc929a3a42161cd478e4f4ff6df00d8da1c3" default)))
 '(elfeed-feeds
   (quote
    ("http://www.kicktraq.com/categories/games/tabletop%20games/latest.rss")))
 '(org-agenda-files (quote ("~/org/praca.org" "~/org/osobiste.org")))
 '(package-selected-packages
   (quote
    (counsel nyan-mode gruvbox-theme neotree nord-theme nord expand-region hungry-delete popup-kill-ring symon dmenu diminish spaceline spacemacs-theme highlight-symbol jedi flycheck auto-complete magit powershell undo-tree swiper ace-window org zenburn-theme yasnippet which-key use-package try org-bullets helm beacon)))
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
