(require 'package)
(setq package-archives
  '(("gnu" . "https://elpa.gnu.org/packages/")
    ("melpa" . "https://melpa.org/packages/")
    ("nongnu" . "https://elpa.nongnu.org/nongnu/"))
  package-archive-priorities
  '(("gnu"    . 5)
    ("melpa"   . 10)
    ("nongnu"  . 0)))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
;; Ensure all packages are downloaded by default
(setq use-package-always-ensure t)

(delete-selection-mode 1)  ;; Delete text by selecting and typing
(global-display-line-numbers-mode 1)  ;; Display line numbers globally
(electric-pair-mode 1)  ;; Auto place closing parentheses
(global-visual-line-mode t)  ;; Enable truncated lines

(menu-bar-mode -1)    ;; Disable GUI menu bar
(scroll-bar-mode -1)  ;; Disable GUI scroll bar
(tool-bar-mode -1)    ;; Disable GUI tool bar

(setq inhibit-splash-screen t)  ;; Skip default startup screen
(setq visible-bell 1)  ;; Set visible bell to disable audible bell

(setq backup-directory-alist
      '((".*" . "~/.local/share/Trash/files")))

(global-set-key (kbd "S-C-<left>")  'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>")  'shrink-window)
(global-set-key (kbd "S-C-<up>")    'enlarge-window)

(use-package diminish)

(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t))

;; Emacs minibuffer config
(use-package emacs
  :custom
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package marginalia
  :bind (:map minibuffer-local-map
       ("M-A" . marginalia-cycle))
  :after vertico
  :init
  (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package consult
  :bind
  (("C-s" . consult-line)
   ("C-x b" . consult-buffer)
   ("M-y" . consult-yank-pop)
   ("M-g g" . consult-goto-line)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 1.0))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :bind ([remap describe-function] . helpful-callable) ([remap describe-command] . helpful-command) ([remap describe-variable] . helpful-variable) ([remap describe-key] . helpful-key))

(use-package ef-themes
:ensure t
:init
(ef-themes-take-over-modus-themes-mode 1)
:config
;; All customisations here.
(setq modus-themes-mixed-fonts t)
(setq modus-themes-italic-constructs t)

;; Load the custom theme
(modus-themes-load-theme 'ef-autumn))

(add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font"))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda ()
			(all-the-icons-dired-mode t))))

;(add-to-list 'default-frame-alist '(alpha-background . 90))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package mood-line
  :config (mood-line-mode)
  ;; Use pretty Fira Code-compatible glyphs
  :custom
  (mood-line-glyph-alist mood-line-glyphs-fira-code))

(use-package org
  :ensure nil
  :defer t
  :bind (("C-c l" . org-store-link)
	 ("C-c a" . org-agenda)
	 ("C-c c" . org-capture))
  :hook org-fragtog
  :custom
  (org-use-speed-commands t)
  (org-startup-folded t)
  (org-todo-keywords
   '((sequence "TODO(t)" "IN-PROGRESS(i)" "|" "DONE(d)")
     (sequence "|" "CANCELED(c)")))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((latex . t)
     (python . t)
     (shell . t) ; bash
     (emacs-lisp . t))))

(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.4))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.3))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.2))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.1)))))

(use-package org-fragtog
  :after org
  :config
  (add-hook 'org-mode-hook #'org-fragtog-mode))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/OneDrive/documents/notes/")
  :config
  (org-roam-db-autosync-mode)

  (setq org-roam-capture-templates
      '(("n" "literature note" plain
         "%?"
         :target (file+head
                  "references/${citar-citekey}.org"
                  ":PROPERTIES:\n:ID: %(org-id-new)\n:NOTER_DOCUMENT: ~/OneDrive/documents/library/${citar-citekey}.pdf\n:END:\n#+title: ${note-title}\n#+created: %U\n#+filetags: :paper:\n\n* TODO Reading Status\n\n* Summary\n\n* Key Concepts\n\n* Quotes\n")
         :unnarrowed t))))

(use-package org-noter
  :after (:any org pdf-tools)
  :config
  ;; Where to find notes
  (setq org-noter-notes-search-path '("~/OneDrive/documents/notes/references/"))
  ;; Where to find PDFs
  (setq org-noter-search-path '("~/OneDrive/documents/library/"))

  ;; Set the split to be vertical (PDF on top/left, Notes on bottom/right)
  (require 'dired)
  (setq org-noter-notes-window-location 'horizontal-split)
  (setq org-noter-always-create-frame nil))

(use-package bibtex
  :custom
  (bibtex-set-dialect 'biblatex)
  (bibtex-user-optional-fields
   '(("file" "Link to a document file." "" )))
  (bibtex-align-at-equal-sign t))

(use-package citar
  :custom
  ;; Bib file that Zotero manages
  (citar-bibliography '("~/OneDrive/documents/references/global.bib"))
  (org-cite-global-bibliography '("~/OneDrive/documents/references/global.bib"))

  ;; Where PDFs are saved
  (citar-library-paths '("~/OneDrive/documents/library/"))

  ;; Make the UI look nice with icons
  (citar-symbols
   `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green) . " ")
     (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue) . " ")
     (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange) . " ")))
  (citar-symbol-separator "  ")

  :bind
  (:map org-mode-map :package org
	("C-c b" . #'org-cite-insert)
	("C-c o" . #'citar-open))
  :hook
  (LaTeX-mode . citar-capf-setup)
  (org-mode . citar-capf-setup)

  :config
  (setq org-cite-insert-processor 'citar)
  (setq org-cite-follow-processor 'citar)
  (setq org-cite-activate-processor 'citar))

(use-package citar-org-roam
  :ensure t
  :after (citar org-roam)
  :config
  (citar-org-roam-mode 1)
  
  ;; Tell Citar: "Use the template named 'n' defined above"
  (setq citar-org-roam-capture-template-key "n")
  
  ;; formatting for the title in the minbuffer
  (setq citar-org-roam-note-title-template "${author} - ${title}"))

(use-package tex
  :ensure auctex
  :defer t
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)
  (add-to-list 'TeX-input-list '(nil "/usr/share/texmf-dist/tex/latex/acmart"))
  ;; to use pdfview with auctex
  (TeX-view-program-selection '((output-pdf "pdf-tools"))
				TeX-source-correlate-start-server t)
  (TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view")))
  (TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  :hook
  (LaTeX-mode . (lambda ()
		    (turn-on-reftex)
		    (setq reftex-plug-into-AUCTeX t)
		    (reftex-isearch-minor-mode)
		    (setq TeX-PDF-mode t)
		    (setq TeX-source-correlate-method 'synctex)
		    (setq TeX-source-correlate-start-server t))))

  ; Latex inline preview
  (setq org-latex-create-formula-image-program 'dvipng)

(use-package company
  :diminish company-mode
  :custom
  ;; Prevent stuttering when typing fast
  (company-idle-delay 0.5)
  ;; Wait 2 chars before searching
  (company-minimum-prefix-length 2)
  (company-tooltip-align-annotations t)
  (company-require-match 'never))  
(add-hook 'after-init-hook 'global-company-mode)

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
	   ("C-M-$" . jinx-languages)))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package dired
  :ensure nil
  :hook all-the-icons)

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :bind (:map pdf-view-mode-map
            ("j" . pdf-view-next-line-or-next-page)
            ("k" . pdf-view-previous-line-or-previous-page)
            ("C-=" . pdf-view-enlarge)
            ("C--" . pdf-view-shrink)
	    ("C-s" . isearch-forward))

  ;; Turn of line numbers when in PDF mode
  :hook
  (pdf-view-mode . (lambda ()
		     (display-line-numbers-mode -1)
		     (pdf-view-midnight-minor-mode)))  ;; auto dark mode
  
  :config
  (pdf-tools-install :no-query)
  (setq pdf-view-use-scaling t)
  (setq pdf-view-use-imagemagick nil)
  ;; Use dark mode
  (setq pdf-view-midnight-colors '("#f5daa3" . "#282828")))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; Prevent emacs from pausing constantly to clean LSP memory
(setq gc-cons-threshold (* 100 1024 1024))

(use-package lsp-mode
  :defer t
  :commands lsp
  :custom
  (lsp-prefer-flymake nil) ; Use flycheck instead of flymake
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding nil)
  (read-process-output-max (* 1024 1024))
  (lsp-keep-workspace-alive nil)
  (lsp-eldoc-hook nil)
  :hook ((python-mode scala-mode)
	   . lsp-deferred))

(use-package lsp-ui
  :after lsp-mode
  :diminish
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-header t)
  (lsp-ui-doc-include-signature t)
  ;; Wait 1 sec before showing documentation group
  (lsp-ui-doc-delay 1.0)
  :hook (python-mode . lsp-deferred))

(defun my-detect-venv-interpreter ()
  "Automatically set the python interpreter to the .venv inside the project."
  (let ((root (locate-dominating-file default-directory ".venv")))
    (when root
      (let ((venv-python (expand-file-name ".venv/bin/python" root)))
        (when (file-exists-p venv-python)
          ;; Tell LSP to use this specific python executable
          (setq-local lsp-pyright-python-executable-cmd venv-python)
          ;; Optional: Update the python-mode shell interpreter too
          (setq-local python-shell-interpreter venv-python))))))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (my-detect-venv-interpreter)
                          (lsp-deferred))))

(use-package yasnippet
  :ensure t
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

(use-package flycheck
:ensure t
:config
(add-hook 'after-init-hook #'global-flycheck-mode))

(use-package yaml-mode
  :ensure t)

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3"))

(setenv "WORKON_HOME" "~/venv/")

(defun uv-run-buffer ()
  "Run the current buffer's file using 'uv run'."
  (interactive)
  (let* ((file-name (buffer-file-name))
         (command (format "uv run %s" (shell-quote-argument file-name))))
    (if file-name
        (progn
          (save-buffer) ;; Auto-save before running
          (compile command))
      (message "Buffer is not visiting a file!"))))

  ;; Bind it to a key
  (global-set-key (kbd "C-c u") 'uv-run-buffer)
