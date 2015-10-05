; -*-Lisp-*-

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))


(defvar custom-packages '(
 evil 
 helm
 neotree
 jsx-mode
 auto-complete
 clojure-mode
 go-mode))

;; Install packages
(dolist (p custom-packages)
  (unless (package-installed-p p)
    (package-install p)))


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


;;
;; Modes
;;

;; Jsx
(require 'jsx-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))

;; Golang
(add-to-list 'load-path "~/dev/go/src/github.com/nsf/gocode/emacs")
(require 'go-autocomplete)
(add-hook 'before-save-hook 'gofmt-before-save)

;; Evil
(require 'evil)
(evil-mode t)

;;
;; Features
;;

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


;; Powerline
(require 'powerline-evil)
(powerline-evil-vim-color-theme)
(display-time-mode t)
(setq powerline-evil-tag-style 'verbose)


;; Auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

