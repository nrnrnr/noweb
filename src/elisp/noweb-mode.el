;; noweb-mode.el - edit noweb files with GNU Emacs
;; Copyright (C) 1995 by Thorsten.Ohl @ Physik.TH-Darmstadt.de
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
;; $Id: noweb-mode.el,v 1.7 1995/05/26 11:51:49 ohl Exp $
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; THIS IS UNRELEASED CODE: IT IS MISSING FUNCTIONALITY AND IT NEEDS CLEANUP ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Put this into your ~/.emacs to use this mode automagically.
;;
;; (autoload 'noweb-mode "noweb-mode" "Editing noweb files." t)
;; (setq auto-mode-alist (append (list (cons "\\.nw$" 'noweb-mode))
;;			      auto-mode-alist))

;; TODO:
;;
;;   * wrapped NOWEB-GOTO-NEXT and NOWEB-GOTO-PREVIOUS
;;
;;   * more range checks and error exits
;;
;;   * a chunk menu
;;
;;   * commands for tangling, weaving, etc.
;;
;;   * ...
;;

;;; Variables

(defconst noweb-mode-RCS-Id
  "$Id: noweb-mode.el,v 1.7 1995/05/26 11:51:49 ohl Exp $")

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
  "Major mode for editing code chunks.")

(defvar noweb-chunk-vector nil
  "Vector of the chunks in this buffer.")

(defvar noweb-isearch-in-progress nil 
  "If non-nil, an incremental search is in progress, and noweb should
   avoid switching modes, since that seems to knock us right out of
   I-Search mode")

(defvar noweb-narrowing nil
  "If not NIL, the display will always be narrowed to the
current chunk pair.")


;;; Setup
(defvar noweb-mode-prefix-map nil
  "Keymap for noweb mode commands.")

(defvar noweb-mode-menu-map nil
  "Keymap for noweb mode menu commands.")

(defvar noweb-mode nil
  "Buff local variable, T iff this buffer is edited in noweb mode.")

(if (not (assq 'noweb-mode minor-mode-alist))
    (setq minor-mode-alist (append minor-mode-alist
				   (list '(noweb-mode " Noweb")))))

(defun noweb-minor-mode ()
  "Minor meta mode for editing noweb files. See NOWEB-MODE."
  (interactive)
  (noweb-mode))

(defun noweb-mode ()
  "Minor meta mode for editing noweb files.  `Meta' refers to the fact
that this minor mode is switching major modes depending on the location
of point.

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

Insertion:
\\[noweb-new-chunk] \tinsert a new chunk

Modes:
\\[noweb-set-doc-mode] \tchange the major mode for editing documentation chunks
\\[noweb-set-code-mode] \tchange the major mode for editing code chunks

Misc:
\\[noweb-update-chunk-vector] \tupdate the markers for chunks
\\[noweb-describe-mode] \tdescribe noweb-mode
\\[noweb-mode-version] \tshow noweb-mode's version in the minibuffer
"
  (interactive)
  (mapcar 'noweb-make-variable-permanent-local
	  '(noweb-mode
	    noweb-chunk-vector
	    post-command-hook
	    noweb-doc-mode
	    noweb-code-mode))
  (setq noweb-mode t)
  (noweb-setup-keymap)
  (add-hook 'post-command-hook 'noweb-post-command-hook)
  (add-hook 'isearch-mode-hook 'noweb-note-isearch-mode)
  (add-hook 'isearch-mode-end-hook 'noweb-note-isearch-mode-end)
  (run-hooks 'noweb-mode-hook)
  (message "nobweb mode: use `M-x noweb-describe-mode' for further information"))

(defun noweb-setup-keymap ()
  ""
  (if noweb-mode-prefix-map
      nil
    (setq noweb-mode-prefix-map (make-sparse-keymap))
    (noweb-bind-keys))
  (if noweb-mode-menu-map
      nil
    (setq noweb-mode-menu-map (make-sparse-keymap "Noweb"))
    (noweb-bind-menu))
  (local-set-key noweb-mode-prefix noweb-mode-prefix-map)
  (local-set-key [menu-bar noweb] (cons "Noweb" noweb-mode-menu-map)))

(defun noweb-bind-keys ()
  "Establish noweb mode key bindings."
  (define-key noweb-mode-prefix-map "\C-n" 'noweb-next-chunk)
  (define-key noweb-mode-prefix-map "\C-p" 'noweb-previous-chunk)
  (define-key noweb-mode-prefix-map "\M-n" 'noweb-goto-next)
  (define-key noweb-mode-prefix-map "\M-p" 'noweb-goto-previous)
  (define-key noweb-mode-prefix-map "c" 'noweb-next-code-chunk)
  (define-key noweb-mode-prefix-map "C" 'noweb-previous-code-chunk)
  (define-key noweb-mode-prefix-map "d" 'noweb-next-doc-chunk)
  (define-key noweb-mode-prefix-map "D" 'noweb-previous-doc-chunk)
  (define-key noweb-mode-prefix-map "g" 'noweb-goto-chunk)
  (define-key noweb-mode-prefix-map "\C-l" 'noweb-update-chunk-vector)
  (define-key noweb-mode-prefix-map "w" 'noweb-copy-chunk-as-kill)
  (define-key noweb-mode-prefix-map "W" 'noweb-copy-chunk-pair-as-kill)
  (define-key noweb-mode-prefix-map "k" 'noweb-kill-chunk)
  (define-key noweb-mode-prefix-map "K" 'noweb-kill-chunk-pair)
  (define-key noweb-mode-prefix-map "m" 'noweb-mark-chunk)
  (define-key noweb-mode-prefix-map "M" 'noweb-mark-chunk-pair)
  (define-key noweb-mode-prefix-map "n" 'noweb-narrow-to-chunk)
  (define-key noweb-mode-prefix-map "N" 'noweb-narrow-to-chunk-pair)
  (define-key noweb-mode-prefix-map "t" 'noweb-toggle-narrowing)
  (define-key noweb-mode-prefix-map "i" 'noweb-new-chunk)
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
  (define-key noweb-mode-menu-map [noweb-update-chunk-vector]
    '("Update the chunk vector" . noweb-update-chunk-vector))
  (define-key noweb-mode-menu-map [noweb-new-chunk]
    '("Insert new chunk" . noweb-new-chunk))
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
  (setq noweb-isearch-in-progress 't))

(defun noweb-note-isearch-mode-end ()
  "Take note of an incremental search having ended"
  (setq noweb-isearch-in-progress nil))

(defun noweb-post-command-hook ()
  "The hook being run after each command in noweb mode."
  (if noweb-isearch-in-progress
      'do-nothing
    (noweb-select-mode)
    ;; reinstall our keymap if the major mode screwed it up:
    (noweb-setup-keymap)))


;;; Chunks

(defun noweb-bol () "Return position of beginning of line"
  (save-excursion (beginning-of-line) (point)))

(defun noweb-eol () "Return position of end of line"
  (save-excursion (end-of-line) (point)))

(defun noweb-this-line () "Return curent line as string"
  (interactive)
  (buffer-substring (noweb-bol) (noweb-eol)))

(defun noweb-update-chunk-vector ()
  "Scan the whole buffer and place a marker at each \"^@\" and \"^<<\".
Record them in NOWEB-CHUNK-VECTOR."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((chunk-list (list (cons 'doc (point-marker)))))
      (while (re-search-forward "^\\(@\\( %def\\)?\\|<<\\(.*\\)>>=\\)" nil t)
	(goto-char (match-beginning 0))
	; (if (eq (point) (point-min)) nil (backward-char)) ; want mode change at bol
        ;  NO! -- blows insertion

	;; If the second subexpression matched, we're still in a code
	;; chunk (sort of), so don't place a marker here.
	(if (not (match-beginning 2))
	    (setq chunk-list
		  ;; If the third subexpression matched, we're seeing
		  ;; a new code chunk.
		  (cons (cons (if (match-beginning 3)
				  (buffer-substring (match-beginning 3) (match-end 3))
				'doc)
			      (point-marker))
			chunk-list))
	    ;; Here, should scan forward either to /^[^@]/, which will
	    ;; start a docs dchunk, or to /^<<.*>>=$/, which will
	    ;; start a code chunk.  I don't know enough emas lisp to
	    ;; do it, so I just set a chunk.
	    (progn
	      (next-line 1)
	      (while (eq (string-match "@ %def" (noweb-this-line)) 0)
		(next-line 1))
	      (setq chunk-list
		    ;; Now we can tell code vs docs
		    (cons 
		     (cons
		      (if (eq (string-match "<<\\(.*\\)>>=" (noweb-this-line))
			      0)
			  (buffer-substring (match-beginning 1) (match-end 1))
			'doc)
		      (point-marker))
		     chunk-list))))
	(next-line 1))
      (setq chunk-list (cons (cons 'doc (point-max-marker)) chunk-list))
      (setq noweb-chunk-vector (vconcat (reverse chunk-list))))))

(defun noweb-find-chunk ()
  ""
  (if (not noweb-chunk-vector)
      (noweb-update-chunk-vector))
  (aref noweb-chunk-vector (noweb-find-chunk-index-buffer)))

(defun noweb-find-chunk-index-buffer ()
  ""
  (noweb-find-chunk-index 0 (1- (length noweb-chunk-vector))))

(defun noweb-find-chunk-index (low hi)
  ""
  (if (= hi (1+ low))
      low
    (let ((med (/ (+ low hi) 2)))
      (if (<= (point) (cdr (aref noweb-chunk-vector med)))
	  (noweb-find-chunk-index low med)
	(noweb-find-chunk-index med hi)))))

(defun noweb-chunk-region ()
  ""
  (interactive)
  (let ((start (noweb-find-chunk-index-buffer)))
    (cons (marker-position (cdr (aref noweb-chunk-vector start)))
	  (marker-position (cdr (aref noweb-chunk-vector (1+ start)))))))

(defun noweb-chunk-pair-region ()
  ""
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
  ""
  (if (< i 0)
      (error "Before first chunk."))
  (if (>= i (length noweb-chunk-vector))
      (error "Beyond last chunk."))
  (aref noweb-chunk-vector i))


;;; Marking

(defun noweb-mark-chunk ()
  ""
  (interactive)
  (let ((r (noweb-chunk-region)))
    (goto-char (car r))
    (push-mark (cdr r) nil t)))

(defun noweb-mark-chunk-pair ()
  ""
  (interactive)
  (let ((r (noweb-chunk-pair-region)))
    (goto-char (car r))
    (push-mark (cdr r) nil t)))


;;; Narrowing

(defun noweb-toggle-narrowing (&optional arg)
  ""
  (interactive "P")
  (if (or arg (not noweb-narrowing))
      (progn
	(setq noweb-narrowing t)
	(noweb-narrow-to-chunk-pair))
    (setq noweb-narrowing nil)
    (widen)))

(defun noweb-narrow-to-chunk ()
  ""
  (interactive)
  (let ((r (noweb-chunk-region)))
    (narrow-to-region (car r) (cdr r))))

(defun noweb-narrow-to-chunk-pair ()
  ""
  (interactive)
  (let ((r (noweb-chunk-pair-region)))
    (narrow-to-region (car r) (cdr r))))


;;; Killing

(defun noweb-kill-chunk ()
  ""
  (interactive)
  (let ((r (noweb-chunk-region)))
    (kill-region (car r) (cdr r))))

(defun noweb-kill-chunk-pair ()
  ""
  (interactive)
  (let ((r (noweb-chunk-pair-region)))
    (kill-region (car r) (cdr r))))

(defun noweb-copy-chunk-as-kill ()
  ""
  (interactive)
  (let ((r (noweb-chunk-region)))
    (copy-region-as-kill (car r) (cdr r))))

(defun noweb-copy-chunk-pair-as-kill ()
  ""
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
		 "Chunk: " alist nil t nil noweb-chunk-history)))
    (goto-char (cdr (assoc chunk alist))))
  (if noweb-narrowing
      (noweb-narrow-to-chunk-pair)))

(defun noweb-build-chunk-alist ()
  ""
  (if (not noweb-chunk-vector)
      (noweb-update-chunk-vector))
  ;; The naive recursive solution will exceed MAX-LISP-EVAL-DEPTH in
  ;; buffers w/ many chunks.  Maybe there is a tail recursivce solution,
  ;; but iterative solutions should be acceptable for dealing with vectors.
  (let ((alist nil)
	(i (1- (length noweb-chunk-vector))))
    (while (>= i 0)
      (let ((chunk (aref noweb-chunk-vector i)))
	(if (stringp (car chunk))
	    (setq alist (cons (cons (car chunk)
				    (marker-position (cdr chunk)))
			      alist))))
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
  ""
  (interactive "p")
  (noweb-goto-next (- cnt)))


;;; Insertion

(defun noweb-new-chunk (name)
  ""
  (interactive "sChunk name: ")
  (noweb-next-doc-chunk)
  (insert "@ \n<<" name ">>=\n")
  (save-excursion
    (insert "@ %def \n"))
  (noweb-update-chunk-vector))


;;; Modes

(defun noweb-select-mode ()
  ""
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
  ""
  (interactive)
  (message "Thorsten's noweb-mode (PRERELEASE). RCS: %s"
	   noweb-mode-RCS-Id))

(defun noweb-describe-mode ()
  ""
  (interactive)
  (describe-function 'noweb-mode))


;;; Debugging

(defun noweb-log (s)
  ""
  (let ((b (current-buffer)))
    (switch-to-buffer (get-buffer-create "*noweb-log*"))
    (setq buffer-read-only nil)
    (insert s "\n")
    (setq buffer-read-only t)
    (switch-to-buffer b)))


;;; Finale

(run-hooks 'noweb-mode-load-hook)
(provide 'noweb-mode)


;; Local Variables:
;; mode:emacs-lisp
;; End:
