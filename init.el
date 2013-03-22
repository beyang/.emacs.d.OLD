(message "Running init.el")
(add-to-list 'load-path (file-name-directory load-file-name))

;; Post-package-load initialization
(add-hook 'after-init-hook #'(lambda () (load "post-init.el")))

;; Keyboard shortcuts
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
(global-set-key (kbd "C-o") 'goto-line)

;; Whitespace
(require 'whitespace)
(global-whitespace-mode 1)
(setq whitespace-action '(auto-cleanup)) ;; automatically clean up bad whitespace
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

