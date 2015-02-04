;; Initialization that must be done after ELPA has loaded all packages
;; goes in this file

(message "Running post-init.el")
(add-hook 'js-mode-hook (lambda () (setq-default indent-tabs-mode t)))
