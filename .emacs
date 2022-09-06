(defun my-kill-emacs ()
  "Save some buffers, then exit unconditionally."
  (interactive)
  (save-some-buffers nil t)
  (kill-emacs))
(global-set-key (kbd "C-x C-c") 'my-kill-emacs)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq-default indent-tabs-mode t)
(setq-default tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)
(cua-mode)
(electric-pair-mode 1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(menu-bar-mode -1)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(add-hook 'after-init-hook #'global-flycheck-mode)
(global-hungry-delete-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes nil)
 '(package-selected-packages '(hungry-delete flycheck)))

(load-theme 'monokai t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#2e2d2c" :foreground "#eae9e9" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 1 :width normal :foundry "default" :family "default")))))
