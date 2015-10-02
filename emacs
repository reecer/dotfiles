
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))


(setq package-enable-at-startup nil)
(package-initialize)
(menu-bar-mode -1)


(require 'evil)
(evil-mode t)


(add-to-list 'load-path "/home/reece/.emacs.d/neotree")
(require 'neotree)
(global-set-key [f9] 'neotree-toggle)
(add-hook 'neotree-mode-hook
    (lambda ()
	(define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
	(define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
	(define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
	(define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))


(require 'helm-mode)
(helm-mode 1)
