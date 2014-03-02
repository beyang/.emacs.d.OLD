(message "Running init.el")
(let ((emacs-home (file-name-directory load-file-name)))
  (add-to-list 'load-path emacs-home)
  (add-to-list 'load-path (concat emacs-home "/manual"))
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

;; Keyboard shortcuts
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
(global-set-key (kbd "C-o") 'goto-line)

;; Whitespace
(require 'whitespace)
(global-whitespace-mode 1)
;; (setq whitespace-action '(auto-cleanup)) ;; automatically clean up bad whitespace
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab)) ;; only show bad whitespace

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

;; Coffee-mode
(setq coffee-tab-width 2)  ; tabs are 2 spaces

;; Handlebars-mode
(require 'handlebars-mode)
(add-to-list 'auto-mode-alist '("\\.hbs.html$" . handlebars-mode))
(add-hook 'handlebars-mode-hook (lambda ()  ; Comment-syntax kludge
				  (setq comment-start "{{!")
				  (setq comment-end "}}")))

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
(ac-set-trigger-key "TAB")
(global-set-key "\M-/" 'auto-complete)
(global-auto-complete-mode t)
(add-to-list 'ac-modes 'go-mode)

(eval-after-load "go-mode"
  '(require 'flymake-go))

;; windmove keys
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

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
(setq-default fill-column 150)
