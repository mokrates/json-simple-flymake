;;;;;; json-simple-pre27-json.el  -- this version is for pre 27.1 emacsen

;;;;;; 2023-08-03 mokrates
;;;;;; really simple but standalone json flymake utilizing the builtin json parser

;;; customize: json-simple-flymake--add-to-js-mode-hook
;;; to start this automatically with javascript-mode

(require 'json)

(defun json-simple-flymake (report-fn &rest _args)
  (funcall report-fn
           (save-excursion
             (goto-char (point-min))
             (condition-case err
                 (progn
                   (json-read)
                   nil)  ;; return no error in case of success (emacs 26.1 doesn't have condition-case :success)
               (json-error
                (let ((fly-regn (flymake-diag-region (current-buffer) (line-number-at-pos) (1+ (current-column)))))
                  (list (flymake-make-diagnostic (current-buffer) (car fly-regn) (cdr fly-regn)
                                                 :error (format "%s: %s '%s'"
                                                                (car err)
                                                                (get (car err) 'error-message)
                                                                (nth 1 err))))))))))
(defun json-simple-setup-flymake-backend ()
  (make-variable-buffer-local 'flymake-diagnostic-functions)
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
