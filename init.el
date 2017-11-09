;; -*- lexical-binding: t -*-

;; show line numbers per line
(global-linum-mode t)
(setq linum-format "%4d \u2502 ")

;; disable backup & autosave file
(setq backup-inhibited t)
(setq auto-save-default nil)

;; disable tabs
(setq tab-width 4)
(setq-default c-basic-offset 4)
(setq-default indent-tabs-mode nil)

;; disable wrap wrap
(setq-default truncate-lines 1)

;; maximize frame when startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; case insesitive search
(setq case-fold-search t)

;;
;; persistent history
(savehist-mode)

;;
;; highlight current line
;; (Courtesy: https://stackoverflow.com/questions/17701576/changing-highlight-line-color-in-emacs)
(global-hl-line-mode 1)
(set-face-background 'hl-line "#f9f5c5")
(set-face-foreground 'highlight nil)
(set-face-attribute hl-line-face nil :underline t)

;;
;; auto-refresh the file
(global-auto-revert-mode t)

;;
;; match parenthesis
(setq show-paren-delay 0)
(show-paren-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(package-selected-packages (quote (elpy auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;
;; include melpa packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("elpy" . "https://jorgenschaefer.gihub.io/packages/") t)

;; activate installed packages
(package-initialize)


;;
;; auto install packages
;; Courtesy: https://stackoverflow.com/questions/10092322/how-to-automatically-install-emacs-packages-by-specifying-a-list-of-package-name
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     ;; (package-installed-p 'evil)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(ensure-package-installed 'auto-complete 'elpy) ;  --> (nil nil) if iedit and magit are already installed


;; enable auto completion
(ac-config-default)
(global-auto-complete-mode t)

;; enable python mode-name
(elpy-enable)

;;
;; mode line customization

;; column number
(setq-default column-number-mode 1)
(display-battery-mode t)
(display-time-mode 1)
(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-client
                mode-line-modified
                ;;mode-line-buffer-identification
                " %64f "
                mode-line-position
                (vc-mode vc-mode)
                "    "
                mode-line-modes
                mode-line-misc-info
                "-%-"
                ))

;;
;; title line
(setq frame-title-format
      '(buffer-file-name "%b - %f" ; File buffer
                         (dired-directory dired-directory ; Dired buffer
                                          (revert-buffer-function "%b" ; Buffer Menu
                                                                  ("%b - Dir: " default-directory))))) ; Plain buffer

;;
;; C IDE
(require 'xcscope)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;;; End: init.el ends here

