; -*-Lisp-*-

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

;; Auto-install helper
(defun ensure-package-installed (&rest packages)
  (mapcar
    (lambda (package)
      (unless (package-installed-p package)
        (package-install package)))
  packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Activate installed packages
(package-initialize)

;; Install packages
(ensure-package-installed 'evil 
                          'helm
                          'neotree
                          'jsx-mode
                          'clojure-mode)

;;
;; Custom settings
;;

;; No menu bar
(menu-bar-mode -1)

;; 2-space indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq evil-shift-width 2)
(defvaralias 'c-basic-offset 'tab-width)

;; Highlight parenthesis
(show-paren-mode 1)

;; Modes
(require 'jsx-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))

;; Evil mode
(require 'evil)
(evil-mode t)

;; Helm
(require 'helm-mode)
(helm-mode 1)

;; NeoTree
(require 'neotree)
(global-set-key [f9] 'neotree-toggle)
(add-hook 'neotree-mode-hook
  (lambda ()
    (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
    (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
    (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
    (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))


;; powerline
(require 'powerline-evil)
;(powerline-default-theme)
(powerline-evil-vim-color-theme)
(display-time-mode t)
(setq powerline-evil-tag-style 'verbose)
