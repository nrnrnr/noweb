;; noweb-mode.el - edit noweb files with GNU Emacs
;; Copyright (C) 1995 by Thorsten.Ohl @ Physik.TH-Darmstadt.de
;;     with a little help from Norman Ramsey <norman@bellcore.com>
;; 
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;; 
;; See bottom of this file for information on language-dependent highlighting
;;
;; $Id: noweb-mode.el,v 1.16 2006/06/12 21:03:57 nr Exp nr $
;; $Name: v2_11b $
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; THIS IS UNRELEASED CODE: IT IS MISSING FUNCTIONALITY AND IT NEEDS CLEANUP ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Put this into your ~/.emacs to use this mode automagically.
;;
;; (autoload 'noweb-mode "noweb-mode" "Editing noweb files." t)
;; (setq auto-mode-alist (append (list (cons "\\.nw$" 'noweb-mode))
;;			      auto-mode-alist))

;; NEWS:
;;
;;   * [tho] M-n q, aka: M-x noweb-fill-chunk
;;
;;   * [tho] M-n TAB, aka: M-x noweb-complete-chunk
;;
;;   * [tho] noweb-occur
;;
;;   * [nr] use `M-n' instead of `C-c n' as default command prefix
;;
;;   * [nr] don't be fooled by
;;
;;     	   @
;;     	   <<foo>>=
;;     	   int foo;
;;     	   @ %def foo
;;     	   Here starts a new documentation chunk!
;;     	   <<bar>>=
;;     	   int bar;
;;
;;  * [nr] switch mode changing commands off during isearch-mode
;;
;;  * [tho] noweb-goto-chunk proposes a default
;;

;; TODO:
;;
;;   * replace obscure hacks like `(stringp (car (noweb-find-chunk)))'
;;     by something more reasonable like `(noweb-code-chunkp)'.
;;
;;   * _maybe_ replace our `noweb-chunk-vector' by text properties.  We
;;     could then use highlighting to jazz up the visual appearance.
;;
;;   * wrapped `noweb-goto-next' and `noweb-goto-previous'
;;
;;   * more range checks and error exits
;;
;;   * commands for tangling, weaving, etc.
;;
;;   * ...
;;

;;; Variables

(defconst noweb-mode-RCS-Id
  "$Id: noweb-mode.el,v 1.16 2006/06/12 21:03:57 nr Exp nr $")

(defconst noweb-mode-RCS-Name
  "$Name: v2_11b $")

(defvar noweb-mode-prefix "\M-n"
  "*Prefix key to use for noweb mode commands.
The value of this variable is checked as part of loading noweb mode.
After that, changing the prefix key requires manipulating keymaps.")

(defvar noweb-mode-load-hook nil
  "Hook that is run after noweb mode is loaded.")

(defvar noweb-mode-hook nil
  "Hook that is run after entering noweb mode.")

(defvar noweb-select-code-mode-hook nil
  "Hook that is run after the code mode is selected.
This is the place to overwrite keybindings of the NOWEB-CODE-MODE.")

(defvar noweb-select-doc-mode-hook nil
  "Hook that is run after the documentation mode is selected.
This is the place to overwrite keybindings of the NOWEB-DOC-MODE.")

(defvar noweb-select-mode-hook nil
  "Hook that is run after the documentation or the code mode is selected.
This is the place to overwrite keybindings of the other modes.")

(defvar noweb-doc-mode 'latex-mode
  "Major mode for editing documentation chunks.")

(defvar noweb-code-mode 'fundamental-mode
  "Major mode for editing code chunks.  This is set to FUNDAMENTAL-MODE
by default, but you might want to change this in the Local Variables
section of your file to something more appropriate, like C-MODE,
FORTRAN-MODE, or even INDENTED-TEXT-MODE.")

(defvar noweb-chunk-vector nil
  "Vector of the chunks in this buffer.")

(defvar noweb-narrowing nil
  "If not NIL, the display will always be narrowed to the
current chunk pair.")

(defvar noweb-electric-@-and-< t
  "If not nil, the keys `@' and `<' will be bound to NOWEB-ELECTRIC-@
and NOWEB-ELECTRIC-<, respectively.")


;;; Setup
(defvar noweb-mode-prefix-map nil
  "Keymap for noweb mode commands.")

(defvar noweb-mode-menu-map nil
  "Keymap for noweb mode menu commands.")

(defvar noweb-mode nil
  "Buffer local variable, T iff this buffer is edited in noweb mode.")

(if (not (assq 'noweb-mode minor-mode-alist))
    (setq minor-mode-alist (append minor-mode-alist
				   (list '(noweb-mode " Noweb")))))

(defun noweb-minor-mode ()
  "Minor meta mode for editing noweb files. See NOWEB-MODE."
  (interactive)
  (noweb-mode))

(defun noweb-mode ()
  "Minor meta mode for editing noweb files.
`Meta' refers to the fact that this minor mode is switching major
modes depending on the location of point.

The following special keystrokes are available in noweb mode:

Movement:
\\[noweb-next-chunk] \tgoto the next chunk
\\[noweb-previous-chunk] \tgoto the previous chunk
\\[noweb-goto-previous] \tgoto the previous chunk of the same name
\\[noweb-goto-next] \tgoto the next chunk of the same name
\\[noweb-goto-chunk] \tgoto a chunk
\\[noweb-next-code-chunk] \tgoto the next code chunk
\\[noweb-previous-code-chunk] \tgoto the previous code chunk
\\[noweb-next-doc-chunk] \tgoto the next documentation chunk
\\[noweb-previous-doc-chunk] \tgoto the previous documentation chunk

Copying/Killing/Marking/Narrowing:
\\[noweb-copy-chunk-as-kill] \tcopy the chunk the point is in into the kill ring
\\[noweb-copy-chunk-pair-as-kill] \tcopy the pair of doc/code chunks the point is in
\\[noweb-kill-chunk] \tkill the chunk the point is in
\\[noweb-kill-chunk-pair] \tkill the pair of doc/code chunks the point is in
\\[noweb-mark-chunk] \tmark the chunk the point is in
\\[noweb-mark-chunk-pair] \tmark the pair of doc/code chunks the point is in
\\[noweb-narrow-to-chunk] \tnarrow to the chunk the point is in
\\[noweb-narrow-to-chunk-pair] \tnarrow to the pair of doc/code chunks the point is in
\\[widen] \twiden
\\[noweb-toggle-narrowing] \ttoggle auto narrowing

Filling:
\\[noweb-fill-chunk] \tfill the chunk at point according to mode.
\\[noweb-fill-paragraph-chunk] \tfill the paragraph at point, restricted to chunk.

Insertion:
\\[noweb-insert-mode-line] \tinsert a line to set this file's code mode
\\[noweb-new-chunk] \tinsert a new chunk at point
\\[noweb-complete-chunk] \tcomplete the chunk name before point.
\\[noweb-electric-@] \tinsert a `@' or start a new doc chunk.
\\[noweb-electric-<] \tinsert a `<' or start a new code chunk.

Modes:
\\[noweb-set-doc-mode] \tchange the major mode for editing documentation chunks
\\[noweb-set-code-mode] \tchange the major mode for editing code chunks

Misc:
\\[noweb-occur] \tfind all occurrences of the current chunk
\\[noweb-update-chunk-vector] \tupdate the markers for chunks
\\[noweb-describe-mode] \tdescribe noweb-mode
\\[noweb-mode-version] \tshow noweb-mode's version in the minibuffer
"
  (interactive)
  (mapcar 'noweb-make-variable-permanent-local
	  '(noweb-mode
	    noweb-narrowing
	    noweb-chunk-vector
	    post-command-hook
	    isearch-mode-hook
	    isearch-mode-end-hook
	    noweb-doc-mode
	    noweb-code-mode))
  (setq noweb-mode t)
  (noweb-setup-keymap)
  (add-hook 'post-command-hook 'noweb-post-command-hook)
  (add-hook 'noweb-select-doc-mode-hook 'noweb-auto-fill-doc-mode)
  (add-hook 'noweb-select-code-mode-hook 'noweb-auto-fill-code-mode)
  (add-hook 'isearch-mode-hook 'noweb-note-isearch-mode)
  (add-hook 'isearch-mode-end-hook 'noweb-note-isearch-mode-end)
  (run-hooks 'noweb-mode-hook)
  (message "noweb mode: use `M-x noweb-describe-mode' for further information"))

(defun noweb-setup-keymap ()
  "Setup the noweb-mode keymap.  This function is rerun every time the
major modes changes, because it might have grabbed the keys."
  (if noweb-mode-prefix-map
      nil
    (setq noweb-mode-prefix-map (make-sparse-keymap))
    (noweb-bind-keys))
  (if noweb-mode-menu-map
      nil
    (setq noweb-mode-menu-map (make-sparse-keymap "Noweb"))
    (noweb-bind-menu))
  (if noweb-electric-@-and-<
      (progn
	(local-set-key "@" 'noweb-electric-@)
	(local-set-key "<" 'noweb-electric-<)))
  (local-set-key "\M-q" 'noweb-fill-paragraph-chunk)
  (local-set-key noweb-mode-prefix noweb-mode-prefix-map)
  (local-set-key [menu-bar noweb] (cons "Noweb" noweb-mode-menu-map)))

    (defun noweb-bind-keys ()
      "Establish noweb mode key bindings."
      (define-key noweb-mode-prefix-map "\C-n" 'noweb-next-chunk)
      (define-key noweb-mode-prefix-map "\C-p" 'noweb-previous-chunk)
      (define-key noweb-mode-prefix-map "\M-n" 'noweb-goto-next)
      (define-key noweb-mode-prefix-map "\M-m" 'noweb-insert-mode-line)
      (define-key noweb-mode-prefix-map "\M-p" 'noweb-goto-previous)
      (define-key noweb-mode-prefix-map "c" 'noweb-next-code-chunk)
      (define-key noweb-mode-prefix-map "C" 'noweb-previous-code-chunk)
      (define-key noweb-mode-prefix-map "d" 'noweb-next-doc-chunk)
      (define-key noweb-mode-prefix-map "D" 'noweb-previous-doc-chunk)
      (define-key noweb-mode-prefix-map "g" 'noweb-goto-chunk)
      (define-key noweb-mode-prefix-map "\C-l" 'noweb-update-chunk-vector)
      (define-key noweb-mode-prefix-map "\M-l" 'noweb-update-chunk-vector)
      (define-key noweb-mode-prefix-map "w" 'noweb-copy-chunk-as-kill)
      (define-key noweb-mode-prefix-map "W" 'noweb-copy-chunk-pair-as-kill)
      (define-key noweb-mode-prefix-map "k" 'noweb-kill-chunk)
      (define-key noweb-mode-prefix-map "K" 'noweb-kill-chunk-pair)
      (define-key noweb-mode-prefix-map "m" 'noweb-mark-chunk)
      (define-key noweb-mode-prefix-map "M" 'noweb-mark-chunk-pair)
      (define-key noweb-mode-prefix-map "n" 'noweb-narrow-to-chunk)
      (define-key noweb-mode-prefix-map "N" 'noweb-narrow-to-chunk-pair)
      (define-key noweb-mode-prefix-map "t" 'noweb-toggle-narrowing)
      (define-key noweb-mode-prefix-map "\t" 'noweb-complete-chunk)
      (define-key noweb-mode-prefix-map "q" 'noweb-fill-chunk)
      (define-key noweb-mode-prefix-map "i" 'noweb-new-chunk)
      (define-key noweb-mode-prefix-map "o" 'noweb-occur)
      (define-key noweb-mode-prefix-map "v" 'noweb-mode-version)
      (define-key noweb-mode-prefix-map "h" 'noweb-describe-mode)
      (define-key noweb-mode-prefix-map "\C-h" 'noweb-describe-mode))
    
  (defun noweb-bind-menu ()
    "Establish noweb mode menu bindings."
    (define-key noweb-mode-menu-map [noweb-mode-version]
      '("Version" . noweb-mode-version))
    (define-key noweb-mode-menu-map [noweb-describe-mode]
      '("Help" . noweb-describe-mode))
    (define-key noweb-mode-menu-map [separator-noweb-help] '("--"))
    (define-key noweb-mode-menu-map [noweb-occur]
      '("Chunk occurrences" . noweb-occur))
    (define-key noweb-mode-menu-map [noweb-update-chunk-vector]
      '("Update the chunk vector" . noweb-update-chunk-vector))
    (define-key noweb-mode-menu-map [noweb-new-chunk]
      '("Insert new chunk" . noweb-new-chunk))
    (define-key noweb-mode-menu-map [noweb-fill-chunk]
      '("Fill current chunk" . noweb-fill-chunk))
    (define-key noweb-mode-menu-map [noweb-complete-chunk]
      '("Complete chunk name" . noweb-complete-chunk))
    (define-key noweb-mode-menu-map [separator-noweb-chunks] '("--"))
    (define-key noweb-mode-menu-map [noweb-toggle-narrowing]
      '("Toggle auto narrowing" . noweb-toggle-narrowing))
    (define-key noweb-mode-menu-map [noweb-narrow-to-chunk-pair]
      '("Narrow to chunk pair" . noweb-narrow-to-chunk-pair))
    (define-key noweb-mode-menu-map [noweb-narrow-to-chunk]
      '("Narrow to chunk" . noweb-narrow-to-chunk))
    (define-key noweb-mode-menu-map [noweb-mark-chunk-pair]
      '("Mark chunk pair" . noweb-mark-chunk-pair))
    (define-key noweb-mode-menu-map [noweb-mark-chunk]
      '("Mark chunk" . noweb-mark-chunk))
    (define-key noweb-mode-menu-map [noweb-kill-chunk-pair]
      '("Kill chunk pair" . noweb-kill-chunk-pair))
    (define-key noweb-mode-menu-map [noweb-kill-chunk]
      '("Kill chunk" . noweb-kill-chunk))
    (define-key noweb-mode-menu-map [noweb-copy-chunk-pair-as-kill]
      '("Copy chunk pair" . noweb-copy-chunk-pair-as-kill))
    (define-key noweb-mode-menu-map [noweb-copy-chunk-as-kill]
      '("Copy chunk" . noweb-copy-chunk-as-kill))
    (define-key noweb-mode-menu-map [separator-noweb-move] '("--"))
    (define-key noweb-mode-menu-map [noweb-next-doc-chunk]
      '("Next documentation chunk" . noweb-next-doc-chunk))
    (define-key noweb-mode-menu-map [noweb-previous-doc-chunk]
      '("Previous documentation chunk" . noweb-previous-doc-chunk))
    (define-key noweb-mode-menu-map [noweb-next-code-chunk]
      '("Next code chunk" . noweb-next-code-chunk))
    (define-key noweb-mode-menu-map [noweb-previous-code-chunk]
      '("Previous code chunk" . noweb-previous-code-chunk))
    (define-key noweb-mode-menu-map [noweb-goto-chunk]
      '("Goto chunk" . noweb-goto-chunk))
    (define-key noweb-mode-menu-map [noweb-goto-next]
      '("Next chunk of same name" . noweb-goto-next))
    (define-key noweb-mode-menu-map [noweb-goto-previous]
      '("Previous chunk of same name" . noweb-goto-previous))
    (define-key noweb-mode-menu-map [noweb-next-chunk]
      '("Next chunk" . noweb-next-chunk))
    (define-key noweb-mode-menu-map [noweb-previous-chunk]
      '("Previous chunk" . noweb-previous-chunk)))
  
(defun noweb-make-variable-permanent-local (var)
  "Declare VAR buffer local, but protect it from beeing killed
by major mode changes."
  (make-variable-buffer-local var)
  (put var 'permanent-local 't))

(defun noweb-note-isearch-mode ()
  "Take note of an incremental search in progress"
  (remove-hook 'post-command-hook 'noweb-post-command-hook))

(defun noweb-note-isearch-mode-end ()
  "Take note of an incremental search having ended"
  (add-hook 'post-command-hook 'noweb-post-command-hook))

(defun noweb-post-command-hook ()
  "The hook being run after each command in noweb mode."
  (noweb-select-mode)
  ;; reinstall our keymap if the major mode screwed it up:
  (noweb-setup-keymap))


;;; Chunks

(defun noweb-update-chunk-vector ()
  "Scan the whole buffer and place a marker at each \"^@\" and \"^<<\".
Record them in NOWEB-CHUNK-VECTOR."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((chunk-list (list (cons 'doc (point-marker)))))
      (while (re-search-forward "^\\(@\\( \\|$\\|\\( %def\\)\\)\\|<<\\(.*\\)>>=\\)" nil t)
	(goto-char (match-beginning 0))
	;; If the 3rd subexpression matched @ %def, we're still in a code
	;; chunk (sort of), so don't place a marker here.
	(if (not (match-beginning 3))
	    (setq chunk-list
		  ;; If the 4th subexpression matched inside <<...>>, we're seeing
		  ;; a new code chunk.
		  (cons (cons (if (match-beginning 4)
				  (buffer-substring (match-beginning 4) (match-end 4))
				'doc)
			      (point-marker))
			chunk-list))
	  ;; Scan forward either to !/^@ %def/, which will start a docs chunk,
	  ;; or to /^<<.*>>=$/, which will start a code chunk.
	  (progn
	    (next-line 1)
	    (while (looking-at "@ %def")
	      (next-line 1))
	    (setq chunk-list
		  ;; Now we can tell code vs docs
		  (cons (cons (if (looking-at "<<\\(.*\\)>>=")
				  (buffer-substring (match-beginning 1) (match-end 1))
				'doc)
			      (point-marker))
			chunk-list))))
	(next-line 1))
      (setq chunk-list (cons (cons 'doc (point-max-marker)) chunk-list))
      (setq noweb-chunk-vector (vconcat (reverse chunk-list))))))

(defun noweb-find-chunk ()
  "Return a pair consisting of the name (or 'DOC) and the
marker of the current chunk."
  (if (not noweb-chunk-vector)
      (noweb-update-chunk-vector))
  (aref noweb-chunk-vector (noweb-find-chunk-index-buffer)))

(defun noweb-find-chunk-index-buffer ()
  "Return the index of the current chunk in NOWEB-CHUNK-VECTOR."
  (noweb-find-chunk-index 0 (1- (length noweb-chunk-vector))))

(defun noweb-find-chunk-index (low hi)
  (if (= hi (1+ low))
      low
    (let ((med (/ (+ low hi) 2)))
      (if (<= (point) (cdr (aref noweb-chunk-vector med)))
	  (noweb-find-chunk-index low med)
	(noweb-find-chunk-index med hi)))))

(defun noweb-chunk-region ()
  "Return a pair consisting of the beginning and end of the current chunk."
  (interactive)
  (let ((start (noweb-find-chunk-index-buffer)))
    (cons (marker-position (cdr (aref noweb-chunk-vector start)))
	  (marker-position (cdr (aref noweb-chunk-vector (1+ start)))))))

(defun noweb-chunk-pair-region ()
  "Return a pair consisting of the beginning and end of the current pair of
documentation and code chunks."
  (interactive)
  (let* ((start (noweb-find-chunk-index-buffer))
	 (end (1+ start)))
    (if (stringp (car (aref noweb-chunk-vector start)))
	(cons (marker-position (cdr (aref noweb-chunk-vector (1- start))))
	      (marker-position (cdr (aref noweb-chunk-vector end))))
      (while (not (stringp (car (aref noweb-chunk-vector end))))
	(setq end (1+ end)))
      (cons (marker-position (cdr (aref noweb-chunk-vector start)))
	    (marker-position (cdr (aref noweb-chunk-vector (1+ end))))))))

(defun noweb-chunk-vector-aref (i)
  (if (< i 0)
      (error "Before first chunk."))
  (if (>= i (length noweb-chunk-vector))
      (error "Beyond last chunk."))
  (aref noweb-chunk-vector i))

(defun noweb-complete-chunk ()
  "Complete the chunk name before point, if any."
  (interactive)
  (if (stringp (car (aref noweb-chunk-vector
			  (noweb-find-chunk-index-buffer))))
      (let ((end (point))
	    (beg (save-excursion
		   (if (re-search-backward "<<"
					   (save-excursion
					     (beginning-of-line)
					     (point))
					   t)
		       (match-end 0)
		     nil))))
	(if beg
	    (let* ((pattern (buffer-substring beg end))
		   (alist (noweb-build-chunk-alist))
		   (completion (try-completion pattern alist)))
	      (cond ((eq completion t))
		    ((null completion)
		     (message "Can't find completion for \"%s\"" pattern)
		     (ding))
		    ((not (string= pattern completion))
		     (delete-region beg end)
		     (insert completion)
		     (if (not (looking-at ">>"))
			 (insert ">>")))
		    (t
		     (message "Making completion list...")
		     (with-output-to-temp-buffer "*Completions*"
		       (display-completion-list (all-completions pattern alist)))
		     (message "Making completion list...%s" "done"))))
	  (message "Not at chunk name...")))
    (message "Not in code chunk...")))


;;; Filling, etc

(defun noweb-hide-code-quotes ()
  "Replace all non blank characters in [[...]] code quotes
in the current buffer (you might want to narrow to the interesting
region first) by `*'.  Return a list of pairs with the position and
value of the original strings." 
  (save-excursion
    (let ((quote-list nil))
      (goto-char (point-min))
      (while (re-search-forward "\\[\\[" nil 'move)
	(let ((beg (match-end 0))
	      (end (if (re-search-forward "\\]\\]" nil t)
		       (match-beginning 0)
		     (point-max))))
	  (goto-char beg)
	  (while (< (point) end)
	    ;; Move on to the next word:
	    (let ((b (progn
		       (skip-chars-forward " \t\n" end)
		       (point)))
		  (e (progn
		       (skip-chars-forward "^ \t\n" end)
		       (point))))
	      (if (> e b)
		  ;; Save the string and a marker to the end of the 
		  ;; replacement text.  A marker to the beginning is
		  ;; useless.  See NOWEB-RESTORE-CODE-QUOTES.
		  (save-excursion
		    (setq quote-list (cons (cons (copy-marker e)
						 (buffer-substring b e))
					   quote-list))
		    (goto-char b)
		    (insert-char ?* (- e b) t)
		    (delete-char (- e b))))))))
      (reverse quote-list))))

(defun noweb-restore-code-quotes (quote-list)
  "Reinsert the strings modified by `noweb-hide-code-quotes'."
  (save-excursion
    (mapcar '(lambda (q)
	       (let* ((e (marker-position (car q)))
		      ;; Slightly inefficient, but correct way to find
		      ;; the beginning of the word to be replaced.
		      ;; Using the marker at the beginning will loose
		      ;; if whitespace has been rearranged
		      (b (save-excursion
			   (goto-char e)
			   (skip-chars-backward "*")
			   (point))))
		 (delete-region b e)
		 (goto-char b)
		 (insert (cdr q))))
	    quote-list)))

(defun noweb-fill-chunk ()
  "Fill the current chunk according to mode.
Run `fill-region' on documentation chunks and `indent-region' on code
chunks."
  (interactive)
  (save-restriction
    (noweb-narrow-to-chunk)
    (if (stringp (car (noweb-find-chunk)))
	(progn
	  ;; Narrow to the code section proper; w/o the first and any
	  ;; index declaration lines.
	  (narrow-to-region (progn
			      (goto-char (point-min))
			      (forward-line 1)
			      (point))
			    (progn
			      (goto-char (point-max))
			      (forward-line -1)
			      (while (looking-at "@")
				(forward-line -1))
			      (forward-line 1)
			      (point)))
	  (if (or indent-region-function indent-line-function)
	      (indent-region (point-min) (point-max) nil)
	    (error "No indentation functions defined in %s!" major-mode)))
      (let ((quote-list (noweb-hide-code-quotes)))
	(fill-region (point-min) (point-max))
	(noweb-restore-code-quotes quote-list)))))

(defun noweb-fill-paragraph-chunk (&optional justify)
  "Fill a paragraph in the current chunk."
  (interactive "P")
  (noweb-update-chunk-vector)
  (save-restriction
    (noweb-narrow-to-chunk)
    (if (stringp (car (noweb-find-chunk)))
	(progn
	  ;; Narrow to the code section proper; w/o the first and any
	  ;; index declaration lines.
	  (narrow-to-region (progn
			      (goto-char (point-min))
			      (forward-line 1)
			      (point))
			    (progn
			      (goto-char (point-max))
			      (forward-line -1)
			      (while (looking-at "@")
				(forward-line -1))
			      (forward-line 1)
			      (point)))
	  (fill-paragraph justify))
      (let ((quote-list (noweb-hide-code-quotes)))
	(fill-paragraph justify)
	(noweb-restore-code-quotes quote-list)))))

(defun noweb-auto-fill-doc-chunk ()
  "Replacement for `do-auto-fill'."
  (save-restriction
    (narrow-to-region (car (noweb-chunk-region))
		      (save-excursion
			(end-of-line)
			(point)))
    (let ((quote-list (noweb-hide-code-quotes)))
      (do-auto-fill)
      (noweb-restore-code-quotes quote-list))))

(defun noweb-auto-fill-doc-mode ()
  "Install the improved auto fill function, iff necessary."
  (if auto-fill-function
      (setq auto-fill-function 'noweb-auto-fill-doc-chunk)))

(defun noweb-auto-fill-code-mode ()
  "Install the default auto fill function, iff necessary."
  (if auto-fill-function
      (setq auto-fill-function 'do-auto-fill)))

;;; Marking

(defun noweb-mark-chunk ()
  "Mark the current chunk."
  (interactive)
  (let ((r (noweb-chunk-region)))
    (goto-char (car r))
    (push-mark (cdr r) nil t)))

(defun noweb-mark-chunk-pair ()
  "Mark the current pair of documentation and code chunks."
  (interactive)
  (let ((r (noweb-chunk-pair-region)))
    (goto-char (car r))
    (push-mark (cdr r) nil t)))


;;; Narrowing

(defun noweb-toggle-narrowing (&optional arg)
  "Toggle if we should narrow the display to the current pair of
documentation and code chunks after each movement.  With argument:
switch narrowing on."
  (interactive "P")
  (if (or arg (not noweb-narrowing))
      (progn
	(setq noweb-narrowing t)
	(noweb-narrow-to-chunk-pair))
    (setq noweb-narrowing nil)
    (widen)))

(defun noweb-narrow-to-chunk ()
  "Narrow the display to the current chunk."
  (interactive)
  (let ((r (noweb-chunk-region)))
    (narrow-to-region (car r) (cdr r))))

(defun noweb-narrow-to-chunk-pair ()
  "Narrow the display to the current pair of documentation and code chunks."
  (interactive)
  (let ((r (noweb-chunk-pair-region)))
    (narrow-to-region (car r) (cdr r))))


;;; Killing

(defun noweb-kill-chunk ()
  "Kill the current chunk."
  (interactive)
  (let ((r (noweb-chunk-region)))
    (kill-region (car r) (cdr r))))

(defun noweb-kill-chunk-pair ()
  "Kill the current pair of chunks."
  (interactive)
  (let ((r (noweb-chunk-pair-region)))
    (kill-region (car r) (cdr r))))

(defun noweb-copy-chunk-as-kill ()
  "Place the current chunk on the kill ring."
  (interactive)
  (let ((r (noweb-chunk-region)))
    (copy-region-as-kill (car r) (cdr r))))

(defun noweb-copy-chunk-pair-as-kill ()
  "Place the current pair of chunks on the kill ring."
  (interactive)
  (let ((r (noweb-chunk-pair-region)))
    (copy-region-as-kill (car r) (cdr r))))


;;; Movement

(defun noweb-sign (n)
  "Return the sign of N."
  (if (< n 0) -1 1))

(defun noweb-next-doc-chunk (&optional cnt)
  "Goto to the Nth documentation chunk from point."
  (interactive "p")
  (widen)
  (let ((start (noweb-find-chunk-index-buffer))
	(i 1))
    (while (<= i (abs cnt))
      (setq start (+ (noweb-sign cnt) start))
      (while (stringp (car (noweb-chunk-vector-aref start)))
	(setq start (+ (noweb-sign cnt) start)))
      (setq i (1+ i)))
    (goto-char (marker-position (cdr (noweb-chunk-vector-aref start))))
    (forward-char 1))
  (if noweb-narrowing
      (noweb-narrow-to-chunk-pair)))

(defun noweb-previous-doc-chunk (&optional n)
  "Goto to the -Nth documentation chunk from point."
  (interactive "p")
  (noweb-next-doc-chunk (- n)))

(defun noweb-next-code-chunk (&optional cnt)
  "Goto to the Nth code chunk from point."
  (interactive "p")
  (widen)
  (let ((start (noweb-find-chunk-index-buffer))
	(i 1))
    (while (<= i (abs cnt))
      (setq start (+ (noweb-sign cnt) start))
      (while (not (stringp (car (noweb-chunk-vector-aref start))))
	(setq start (+ (noweb-sign cnt) start)))
      (setq i (1+ i)))
    (goto-char (marker-position (cdr (noweb-chunk-vector-aref start))))
    (next-line 1))
  (if noweb-narrowing
      (noweb-narrow-to-chunk-pair)))

(defun noweb-previous-code-chunk (&optional n)
  "Goto to the -Nth code chunk from point."
  (interactive "p")
  (noweb-next-code-chunk (- n)))

(defun noweb-next-chunk (&optional n)
  "If in a documentation chunk, goto to the Nth documentation
chunk from point, else goto to the Nth code chunk from point."
  (interactive "p")
  (if (stringp (car (aref noweb-chunk-vector
			  (noweb-find-chunk-index-buffer))))
      (noweb-next-code-chunk n)
    (noweb-next-doc-chunk n)))

(defun noweb-previous-chunk (&optional n)
  "If in a documentation chunk, goto to the -Nth documentation
chunk from point, else goto to the -Nth code chunk from point."
  (interactive "p")
  (noweb-next-chunk (- n)))

(defvar noweb-chunk-history nil
  "")

(defun noweb-goto-chunk ()
  "Goto the named chunk."
  (interactive)
  (widen)
  (let* ((completion-ignore-case t)
	 (alist (noweb-build-chunk-alist))
	 (chunk (completing-read
		 "Chunk: " alist nil t
		 (noweb-goto-chunk-default)
		 noweb-chunk-history)))
    (goto-char (cdr (assoc chunk alist))))
  (if noweb-narrowing
      (noweb-narrow-to-chunk-pair)))

(defun noweb-goto-chunk-default ()
  (save-excursion
    (if (re-search-backward "<<"
			    (save-excursion
			      (beginning-of-line)
			      (point))
			    'move)
	(goto-char (match-beginning 0)))
    (if (re-search-forward "<<\\(.*\\)>>"
			   (save-excursion
			     (end-of-line)
			     (point))
			   t)
	(buffer-substring (match-beginning 1) (match-end 1))
      nil)))

(defun noweb-build-chunk-alist ()
  (if (not noweb-chunk-vector)
      (noweb-update-chunk-vector))
  ;; The naive recursive solution will exceed MAX-LISP-EVAL-DEPTH in
  ;; buffers w/ many chunks.  Maybe there is a tail recursivce solution,
  ;; but iterative solutions should be acceptable for dealing with vectors.
  (let ((alist nil)
	(i (1- (length noweb-chunk-vector))))
    (while (>= i 0)
      (let* ((chunk (aref noweb-chunk-vector i))
	     (name (car chunk))
	     (marker (cdr chunk)))
	(if (and (stringp name)
		 (not (assoc name alist)))
	    (setq alist (cons (cons name marker) alist))))
      (setq i (1- i)))
    alist))

(defun noweb-goto-next (&optional cnt)
  "Goto the continuation of the current chunk."
  (interactive "p")
  (widen)
  (if (not noweb-chunk-vector)
      (noweb-update-chunk-vector))
  (let ((start (noweb-find-chunk-index-buffer)))
    (if (not (stringp (car (aref noweb-chunk-vector start))))
	(setq start (1+ start)))
    (if (stringp (car (noweb-chunk-vector-aref start)))
	(let ((name (car (noweb-chunk-vector-aref start)))
	      (i 1))
	  (while (<= i (abs cnt))
	    (setq start (+ (noweb-sign cnt) start))
	    (while (not (equal (car (noweb-chunk-vector-aref start))
			       name))
	      (setq start (+ (noweb-sign cnt) start)))
	    (setq i (1+ i)))
	  (goto-char (marker-position
		      (cdr (noweb-chunk-vector-aref start))))
	  (next-line 1))))
  (if noweb-narrowing
      (noweb-narrow-to-chunk-pair)))

(defun noweb-goto-previous (&optional cnt)
  "Goto the previous chunk."
  (interactive "p")
  (noweb-goto-next (- cnt)))

(defun noweb-occur (arg)
  "Find all occurences of the current chunk.
This function simply runns OCCUR on \"<<NAME>>\"."
  (interactive "P")
  (let ((n (if (and arg
		    (numberp arg))
	       arg
	     0))
	(idx (noweb-find-chunk-index-buffer)))
    (if (stringp (car (aref noweb-chunk-vector idx)))
	(occur (regexp-quote (concat "<<"
				     (car (aref noweb-chunk-vector idx))
				     ">>"))
	       n)
      (setq idx (1+ idx))
      (while (not (stringp (car (aref noweb-chunk-vector idx))))
	(setq idx (1+ idx)))
      (occur (regexp-quote (concat "<<"
				   (car (aref noweb-chunk-vector idx))
				   ">>"))
			   n))))


;;; Insertion

(defun noweb-new-chunk (name)
  "Insert a new chunk."
  (interactive "sChunk name: ")
  (insert "@ \n<<" name ">>=\n")
  (save-excursion
    (insert "@ %def \n"))
  (noweb-update-chunk-vector))

(defun noweb-at-beginning-of-line ()
  (equal (save-excursion
	   (beginning-of-line)
	   (point))
	 (point)))

(defun noweb-electric-@ (arg)
  "Smart incarnation of `@', starting a new documentation chunk, maybe.
If given an numerical argument, it will act just like the dumb `@'.
Otherwise and if at the beginning of a line in a code chunk:
insert \"@ \" and update the chunk vector."
  (interactive "P")
  (if arg
      (self-insert-command (if (numberp arg) arg 1))
    (if (and (noweb-at-beginning-of-line)
	     (stringp (car (noweb-find-chunk))))
	(progn
	  (insert "@ ")
	  (noweb-update-chunk-vector))
      (self-insert-command 1))))

(defun noweb-electric-< (arg)
  "Smart incarnation of `<', starting a new code chunk, maybe.
If given an numerical argument, it will act just like the dumb `<'.
Otherwise and if at the beginning of a line in a documentation chunk:
insert \"<<>>=\" and a newline if necessary.  Leave point in the middle
and and update the chunk vector."
  (interactive "P")
  (if arg
      (self-insert-command (if (numberp arg) arg 1))
    (if (and (noweb-at-beginning-of-line)
	     (not (stringp (car (noweb-find-chunk)))))
	(progn
	  (insert "<<")
	  (save-excursion
	    (insert ">>=")
	    (if (not (looking-at "\\s *$"))
		(newline)))
	  (noweb-update-chunk-vector))
      (self-insert-command 1))))


;;; Modes

(defun noweb-select-mode ()
  "Select NOWEB-DOC-MODE or NOWEB-CODE-MODE, as appropriate."
  (interactive)
  (if (stringp (car (noweb-find-chunk)))
      ;; Inside a code chunk
      (if (equal major-mode noweb-code-mode)
	  nil
	(funcall noweb-code-mode)
	(run-hooks 'noweb-select-code-mode-hook)
	(run-hooks 'noweb-select-mode-hook))
    ;; Inside a documentation chunk
    (if (equal major-mode noweb-doc-mode)
	nil
      (funcall noweb-doc-mode)
      (run-hooks 'noweb-select-doc-mode-hook)
      (run-hooks 'noweb-select-mode-hook))))

(defun noweb-set-doc-mode (mode)
  "Change the major mode for editing documentation chunks."
  (interactive "CNew major mode for documentation chunks: ")
  (setq noweb-doc-mode mode))

(defun noweb-set-code-mode (mode)
  "Change the major mode for editing code chunks."
  (interactive "CNew major mode for code chunks: ")
  (setq noweb-code-mode mode))


;;; Misc

(defun noweb-mode-version ()
  "Echo the RCS identification of noweb mode."
  (interactive)
  (message "Thorsten's noweb-mode (PRERELEASE). RCS: %s"
	   noweb-mode-RCS-Id))

(defun noweb-describe-mode ()
  "Describe noweb mode."
  (interactive)
  (describe-function 'noweb-mode))

(defun noweb-insert-mode-line (arg)
  "Insert line that will set the noweb mode of this file in emacs"
  (interactive "CNoweb code mode for this file: ")
  (save-excursion
    (goto-char (point-min))
    (insert "% -*- mode: Noweb; noweb-code-mode: " (symbol-name arg) " -*-\n")))


;;; Debugging

(defun noweb-log (s)
  (let ((b (current-buffer)))
    (switch-to-buffer (get-buffer-create "*noweb-log*"))
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert s)
    (setq buffer-read-only t)
    (switch-to-buffer b)))


;;; Finale

(run-hooks 'noweb-mode-load-hook)
(provide 'noweb-mode)


;;; Code-dependent highlighting

;;  *****
;;  
;;  Adding highlighting to noweb-mode.el
;;  
;;  Here is a description of how one can add highlighting via the
;;  font-lock package to noweb buffers.  It uses the hooks provided by
;;  noweb-mode.el.  The solution provides the following features:
;;  1) The documentation chunks are highlighted in the noweb-doc-mode
;;  (e.g., LaTeX).
;;  2) The code chunks without mode comments (-*- mode -*-) arew
;;  highlighted in the noweb-code-mode.
;;  3) The code chunks with mode comments (-*- mode -*-) one the first
;;  line of the chunk, are highlighted in the mode in the comment.
;;  
;;  For example, given the file:
;;  
;;    % -*- mode: Noweb; noweb-code-mode: c-mode -*-
;;  
;;    \begin{itemize}
;;    \item a main routine written in C,
;;    \item a log configuration file parser written in YACC, and
;;    \item a lexical analyzer written in Lex.
;;    \end{itemize}
;;  
;;    <<warning c comment>>=
;;    /* DO NOT EDIT ME! */
;;    /* This file was automatically generated from %W% (%G%). */
;;    @
;;  
;;    <<warning nroff comment>>=
;;    .\" -*- nroff -*-
;;    .\" DO NOT EDIT ME!
;;    .\" This file was automatically generated from %W% (%G%).
;;    @
;;  
;;  The LaTeX list is highlighted in latex-mode (the default noweb doc
;;  mode), the chunk <<warning c comment>> is highlighted in c-mode (the
;;  default noweb code mode), and the chunk <<warning nroff comment>> is
;;  highlighted in nroff-mode due to the "-*- nroff -*-" comment.
;;  
;;  Chunks are highlighted each time point moves into them from a
;;  different mode.
;;  
;;  The solution has the following drawbacks:
;;  1) It won't work if global-font-lock-mode is set.
;;  2) The ighlighting sometimes get confuses.  For example, a "$" in a
;;  previous code chunk throws the highlighting in the LaTeX math mode.
;;  (Note this problem exist in LaTeX highlighting if the "$" is in a
;;  verbatim as well.)  Similarly a lone "'" in a previous LaTeX chunk can
;;  cause problems in code mode highlighting.
;;  
;;  To use highlighing, add the following to your .emacs:
;;  
;;  ;;; We need this variable since we will be overwriting the
;;  ;;; noweb-code-mode from time to time.
;;  (defvar my-noweb-main-code-mode nil
;;    "Variable used to save the default noweb-code-mode.")
;;  
;;  (defun my-set-noweb-code-mode (beg-pt end-pt)
;;    "Set the noweb-code-mode for the chunk between BEG-PT and END-PT."
;;    (let (beg end done mode)
;;  	;; Reset code-mode to default and then check for a mode comment.
;;  	(setq mode my-noweb-main-code-mode)
;;  	(save-excursion
;;  	  (goto-char beg-pt)
;;  	  (beginning-of-line 2)
;;  	  (and (search-forward "-*-"
;;  			       (save-excursion (end-of-line) (point))
;;  			       t)
;;  	       (progn
;;  		 (skip-chars-forward " \t")
;;  		 (setq beg (point))
;;  		 (search-forward "-*-"
;;  				 (save-excursion (end-of-line) (point))
;;  				 t))
;;  	       (progn
;;  		 (forward-char -3)
;;  		 (skip-chars-backward " \t")
;;  		 (setq end (point))
;;  		 (goto-char beg)
;;  		 (setq mode (intern
;;  			     (concat
;;  			      (downcase (buffer-substring beg end))
;;  			      "-mode")))))
;;  	  (noweb-set-code-mode mode))))
;;  
;;  (defun my-noweb-pre-select-code-mode-hook ()
;;    "Set the code mode for the current chunk."
;;    (let ((r (noweb-chunk-region)))
;;  	(my-set-noweb-code-mode (car r) (cdr r))
;;  	t))
;;  
;;  (defun my-noweb-select-mode-hook ()
;;    "Fontify the current chunk based on the chunks mode."
;;    ;; If this is the first time, save the default noweb-code-mode.
;;    (if my-noweb-first-time
;;  	  (progn
;;  	    (setq my-noweb-first-time nil)
;;  	    (setq my-noweb-main-code-mode noweb-code-mode)))
;;    (font-lock-set-defaults)
;;    (let ((r (noweb-chunk-region)))
;;  	(save-excursion
;;  	  (font-lock-fontify-region (car r) (cdr r))
;;  	  t)))
;;  
;;  (defun my-noweb-mode-hook()
;;    (setq my-noweb-first-time t))
;;  
;;  (add-hook 'noweb-mode-hook 'my-noweb-mode-hook)
;;  (add-hook 'noweb-select-mode-hook 'my-noweb-select-mode-hook)
;;  (add-hook 'noweb-pre-select-code-mode-hook 'my-noweb-pre-select-code-mode-hook)
;;  
;;  *****
;;  
;;  Adnan Yaqub (AYaqub@orga.com)
;;  ORGA Kartensysteme GmbH // An der Kapelle 2 // D-33104 Paderborn // Germany
;;  Tel. +49 5254 991-823 //Fax. +49 5254 991-749




;; Local Variables:
;; mode:emacs-lisp
;; End:
