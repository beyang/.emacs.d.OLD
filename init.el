(message "Running init.el")
(let ((emacs-home (file-name-directory load-file-name)))
  (add-to-list 'load-path emacs-home)
  (add-to-list 'load-path (concat emacs-home "/manual"))
  (add-to-list 'load-path (concat emacs-home "/manual/emacs-sourcegraph-mode"))
  ;; (add-to-list 'load-path (concat emacs-home "/manual/go-mode") t)
)

;; Post-package-load initialization
(add-hook 'after-init-hook #'(lambda () (load "post-init.el")))

;; Marmalade package repo
(require 'package)
(add-to-list 'package-archives
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

;; Show matching parens
(show-paren-mode 1)
(setq show-paren-delay 0)
(defadvice show-paren-function
  (after show-matching-paren-offscreen activate)
  "If the matching paren is offscreen, show the matching line in the
	echo area. Has no effect if the character before point is not of
	the syntax class ')'."
  (interactive)
  (let* ((cb (char-before (point)))
	 (matching-text (and cb
			     (char-equal (char-syntax cb) ?\) )
			     (blink-matching-open))))
    (when matching-text (message matching-text))))

;; Open pop-to-buffer in vertically adjacent buffer (rather than horizontal)
(setq split-height-threshold nil)

;; .zsh files
(add-to-list 'auto-mode-alist '("\\.zsh" . sh-mode))

;; revert-all-buffers
(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (not (buffer-modified-p)))
	(revert-buffer t t t) )))
  (message "Refreshed open files.") )

;; js-mode
(setq js-indent-level 2)
(add-hook 'js-mode-hook (lambda () (setq indent-tabs-mode t
                                    tab-width 4
                                    js-indent-level 4
                                    c-basic-offset 4)))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))

;; go-mode latest (hard-linked to $GOROOT/misc/emacs/...), use goimports instead of gofmt
(setq gofmt-command "goimports")
(require 'go-mode-load)
(defun go-custom ()
  "go-mode-hook"
  (add-hook 'before-save-hook 'gofmt-before-save)
  (set (make-local-variable 'tab-width) 4))

(add-hook 'go-mode-hook
	  '(lambda () (go-custom)))

(add-hook 'go-mode-hook (lambda () (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))
(add-hook 'go-mode-hook (lambda () (local-set-key (kbd "C-c i") 'go-goto-imports)))
(add-hook 'go-mode-hook (lambda () (local-set-key (kbd "M-.") 'godef-jump)))

;; golang autocomplete
(require 'go-autocomplete)
(require 'auto-complete-config)
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")              ; M-/ still triggers emacs-style autocomplete, TAB gives a fancy menu
(global-auto-complete-mode t)
(add-to-list 'ac-modes 'go-mode)

(eval-after-load "go-mode"
  '(require 'flymake-go))

;; yaml-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'ac-modes 'markdown-mode)

;; sass-mode
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(setq scss-compile-at-save nil)

;; Note: disabled the parens and quote witch in emacs starter kit
;; (search 'ack paredit-open-curly .')

;; misc
(setq-default fill-column 120)

(require 'sourcegraph-mode)
(put 'downcase-region 'disabled nil)


;; el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)


;; jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional
