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
 '(org-agenda-files (quote ("~/org/praca.org" "~/org/osobiste.org")))
 '(package-selected-packages
   (quote
    (auto-package-update csharp-mode yasnippet-snippets counsel nyan-mode gruvbox-theme neotree nord-theme nord expand-region hungry-delete popup-kill-ring symon dmenu diminish spaceline spacemacs-theme highlight-symbol jedi flycheck auto-complete magit powershell undo-tree swiper ace-window org zenburn-theme yasnippet which-key use-package try org-bullets helm beacon)))
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
