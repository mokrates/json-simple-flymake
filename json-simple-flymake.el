;;;;;; 2023-08-02 mokrates
;;;;;; really simple but standalone json flymake utilizing the builtin json parser

;;; customize: json-simple-flymake--add-to-js-mode-hook
;;; to start this automatically with javascript-mode

(defun json-simple-flymake (report-fn &rest _args)
  (funcall report-fn
  (save-excursion
    (goto-char (point-min)) 
    (condition-case err
	(json-parse-buffer)
      ((json-end-of-file
	json-error
	json-object-too-deep
	json-out-of-memory
	json-parse-error)
       (let ((fly-regn (flymake-diag-region (current-buffer) (nth 3 err) (nth 4 err))))
	 (list (flymake-make-diagnostic (current-buffer) (car fly-regn) (cdr fly-regn) :error (nth 1 err)))))
      (:success ())))))

(defun json-simple-setup-flymake-backend ()
  (add-hook 'flymake-diagnostic-functions 'json-simple-flymake)

  (when json-simple-flymake--enable-help
    (if (listp help-at-pt-display-when-idle)
	(add-to-list 'help-at-pt-display-when-idle 'flymake-diagnostic)
      (setf help-at-pt-display-when-idle '(flymake-diagnostic)))
    (help-at-pt-set-timer)))

(defgroup json-simple-flymake-group
  nil
  "json-simple-flymake: a simple flymake checker for json")

(defcustom json-simple-flymake--add-to-js-mode-hook nil
  "Add json-simple-flymake to js-mode-hook.
This is only really useful, if you don't edit javascript much but
only json. This is NOT a javascript linter"
  :type 'boolean
  :group 'json-simple-flymake-group)

(defcustom json-simple-flymake--enable-help t
  "enable help at point for json-simple-flymake"
  :type 'boolean
  :group 'json-simple-flymake-group)

(when json-simple-flymake--add-to-js-mode-hook
  (add-hook 'js-mode-hook 'json-simple-setup-flymake-backend)
  (add-hook 'js-mode-hook (lambda () (flymake-mode t))))
