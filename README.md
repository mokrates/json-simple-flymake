# json-simple-flymake
flymake mode for json using emacs' builtin json-parse-buffer

## install ##

Throw `json-simple-flymake.el` into your `~/.emacs.d/` and add `(load
"~/.emacs.d/json-simple-flymake.el")` at the end of your `~/.emacs`.

## Customize ##

    M-x customize-group RET json-simple-flymake-group
	
## Limitations ##

only ever marks but one error, because we use json-parse-buffer, which
doesn't to more. But hey, more than nothing for a devop who want's to
edit some json configs and not install a zillion jiggabytes of npm
madness for jsonlint, right?
