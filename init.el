(message "Running init.el")
(let ((emacs-home (file-name-directory load-file-name)))
  (add-to-list 'load-path emacs-home)
  (add-to-list 'load-path (concat emacs-home "/manual"))
  (add-to-list 'load-path (concat emacs-home "/manual/go-mode") t)
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

;; go-mode latest (hard-linked to $GOROOT/misc/emacs/...)
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

;; (eval-after-load "go-mode"
;;   '(require 'flymake-go))

;; ;; js tabs
;; (add-hook 'js2-mode-hook 'my-disable-indent-tabs-mode)
;; (defun my-disable-indent-tabs-mode ()
;;   (set-variable 'indent-tabs-mode nil))
;; (setq-default js2-basic-offset 2) ; 2 spaces for indentation (if you prefer 2 spaces instead of default 4 spaces for tab)
;; (setq js2-basic-offset 2) ; 2 spaces for indentation (if you prefer 2 spaces instead of default 4 spaces for tab)

;; (eval-after-load "js2-mode"
;;   '(progn
;;      (setq js2-missing-semi-one-line-override t)
;;      (setq-default js2-basic-offset 2) ; 2 spaces for indentation (if you prefer 2 spaces instead of default 4 spaces for tab)

;;      ;; following is from http://www.emacswiki.org/emacs/Js2Mode
;;      (add-hook 'js2-post-parse-callbacks 'my-js2-parse-global-vars-decls)
;;      (defun my-js2-parse-global-vars-decls ()
;;        (let ((btext (replace-regexp-in-string
;;                      ": *true" " "
;;                      (replace-regexp-in-string "[\n\t ]+" " " (buffer-substring-no-properties 1 (buffer-size)) t t))))
;;          (setq js2-additional-externs
;;                (split-string
;;                 (if (string-match "/\\* *global *\\(.*?\\) *\\*/" btext) (match-string-no-properties 1 btext) "")
;;                 " *, *" t))
;;          ))
;;      ))

;; golang autocomplete
(require 'go-autocomplete)
(require 'auto-complete-config)
(setq ac-auto-start nil)
;; (ac-set-trigger-key "TAB")
(global-set-key "\M-/" 'auto-complete)
