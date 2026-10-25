;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'kanagawa-wave)

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 12.0)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 12.0)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Keep a block cursor in Evil insert state.
(after! evil
  (setq evil-insert-state-cursor 'box))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Keep source indexes current and install tree-sitter grammars on first use.
(setq imenu-auto-rescan t
      treesit-auto-install-grammar 'always)

;; Doom's archived Dart grammar fork is incompatible with dart-ts-mode.
(after! treesit
  (setf (alist-get 'dart treesit-language-source-alist)
        '("https://github.com/UserNobody14/tree-sitter-dart"))
  (setf (alist-get 'typst treesit-language-source-alist)
        '("https://github.com/Ziqi-Yang/tree-sitter-typst")))

;; Use the mise-managed TypeScript compiler when a project has no local copy.
(after! eglot
  (add-to-list 'eglot-server-programs
               '(((js-mode :language-id "javascript")
                  (js-ts-mode :language-id "javascript")
                  (tsx-ts-mode :language-id "typescriptreact")
                  (typescript-ts-mode :language-id "typescript")
                  (typescript-mode :language-id "typescript"))
                 . ("typescript-language-server" "--stdio"
                    :initializationOptions
                    (lambda (_server)
                      (let ((shim (executable-find "tsserver")))
                        (list
                         :tsserver
                         (list
                          :fallbackPath
                          (with-temp-buffer
                            (insert-file-contents shim)
                            (goto-char (point-min))
                            (if (re-search-forward
                                 "^# cmd-shim-target=\\(.+\\)$" nil t)
                                (match-string 1)
                              shim))))))))))

;; Navigate Dired like a normal Evil buffer: left/up/down/right.
(after! dired
  (map! :map dired-mode-map
        :n "h" #'dired-up-directory
        :n "j" #'dired-next-line
        :n "k" #'dired-previous-line
        :n "l" #'dired-find-file))

(after! dirvish
  (map! :map dirvish-mode-map
        :n "h" #'dired-up-directory
        :n "j" #'dired-next-line
        :n "k" #'dired-previous-line
        :n "l" #'dired-find-file))

;; A daemon has no graphical frame while it initializes.  Reapply Doom's
;; frame-dependent UI after each emacsclient frame is created so its theme,
;; fonts, and modeline match a normally launched GUI Emacs.
(defun my/refresh-doom-client-frame-ui (&optional frame)
  (with-selected-frame (or frame (selected-frame))
    (doom-init-fonts-h)
    (doom-init-theme-h)
    (when (fboundp 'doom-modeline-refresh-bars)
      (doom-modeline-refresh-bars))
    (force-mode-line-update t)))
(add-hook 'server-after-make-frame-hook #'my/refresh-doom-client-frame-ui t)

;; Generic .scm files use Gambit/Geiser; .ss and .pkg use Gerbil.
;; Make cmuscheme's command buffer-local before gerbil-mode assigns it.
(after! cmuscheme
  (make-variable-buffer-local 'scheme-program-name)
  (setq-default scheme-program-name "gsi -:d-"))

(after! geiser
  (setq geiser-active-implementations '(gambit)
        geiser-default-implementation 'gambit))

;; Gerbil source files use gerbil-mode for Gerbil-aware font-lock and
;; indentation.  The LSP hookup is intentionally optional: Gerbil 0.18
;; ships no LSP server, but this becomes active as soon as `gerbil-lsp` (or
;; the command named by GERBIL_LSP_COMMAND) is installed.
(use-package! gerbil-mode
  :mode (("\\.ss\\'" . gerbil-mode)
         ("\\.pkg\\'" . gerbil-mode))
  :init
  (setq gerbil-program-name "gxi")
  (defun my/gerbil-repl ()
    "Open Gerbil's REPL, separate from Gambit's Geiser REPL."
    (interactive)
    (run-scheme gerbil-program-name))
  (defun my/gerbil-send-buffer (&optional and-go)
    "Evaluate the current Gerbil buffer, optionally selecting its REPL."
    (interactive "P")
    (scheme-send-region (point-min) (point-max))
    (when and-go (switch-to-scheme t)))
  :config
  (set-repl-handler! 'gerbil-mode #'my/gerbil-repl
    :persist t
    :send-region #'scheme-send-region
    :send-buffer #'my/gerbil-send-buffer)
  (set-eval-handler! 'gerbil-mode #'scheme-send-region)
  (map! :map gerbil-mode-map
        :localleader
        :desc "Gerbil REPL" "'" #'my/gerbil-repl
        (:prefix ("e" . "evaluate")
         "b" #'my/gerbil-send-buffer
         "B" (cmd! (my/gerbil-send-buffer t))
         "e" #'scheme-send-last-sexp
         "d" #'scheme-send-definition
         "D" #'scheme-send-definition-and-go
         "r" #'scheme-send-region
         "R" #'scheme-send-region-and-go)
        :prefix ("l" . "language server")
        "a" #'eglot-code-actions
        "d" #'eglot-find-declaration
        "D" #'eglot-find-definition
        "f" #'eglot-format
        "h" #'eglot-hover
        "r" #'eglot-rename
        "R" #'eglot-reconnect))

(use-package! gambit
  :hook (inferior-scheme-mode . gambit-inferior-mode))

;; Optional Gerbil LSP; REPL support does not depend on a language server.
(use-package! eglot
  :defer t
  :init
  (defvar my/gerbil-lsp-command
    (split-string-and-unquote
     (or (getenv "GERBIL_LSP_COMMAND") "gerbil-lsp")))

  (defun my/gerbil-eglot-ensure ()
    "Start Gerbil Eglot only when a Gerbil LSP server is installed."
    (when (executable-find (car my/gerbil-lsp-command))
      (eglot-ensure)))

  (add-hook 'gerbil-mode-hook #'my/gerbil-eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               `(gerbil-mode . ,my/gerbil-lsp-command)))

;; Typst: use the project root for shared YAML and other files outside resume/.
(use-package! typst-ts-mode
  :mode "\\.typ\\'"
  :hook (typst-ts-mode . my/typst-setup)
  :init
  (defun my/typst-setup ()
    "Configure project-aware Typst compilation and start Eglot."
    (when-let* ((project (project-current nil))
                (root (project-root project)))
      (setq-local typst-ts-compile-options
                  (concat "--root " (shell-quote-argument root))
                  typst-ts-watch-options (list "--root" root)
                  eglot-workspace-configuration
                  `(:tinymist (:rootPath ,root))))
    (eglot-ensure))
  :config
  ;; Open the PDF in its own viewer session, independent of browsers and Emacs.
  (setq typst-ts-preview-function
        (lambda (file)
          (start-process
           "Typst PDF preview" "*Typst PDF preview*"
           "setsid" "-f" "flatpak" "run" "--user" "--file-forwarding"
           "org.gnome.Papers" "@@" file "@@")))
  (map! :map typst-ts-mode-map
        :localleader
        :desc "Compile PDF" "c" #'typst-ts-compile
        :desc "Compile and preview PDF" "p" #'typst-ts-compile-and-preview
        :desc "Watch and rebuild PDF" "w" #'typst-ts-watch-mode
        :desc "Format Typst" "f" #'eglot-format))

(after! eglot
  (add-to-list 'eglot-server-programs '(typst-ts-mode . ("tinymist"))))

;; Render Markdown inside Emacs with EWW; refresh the preview on save.
(after! markdown-mode
  (map! :map markdown-mode-map
        :localleader
        :desc "Preview in Emacs" "P" #'markdown-live-preview-mode))

;; Forge reuses glab's existing GitLab credential; no second token file.
(after! auth-source
  (defun my/gitlab-forge-secret ()
    "Retrieve the existing GitLab token without exposing process output."
    (with-temp-buffer
      (let ((status (call-process "glab" nil (list t nil) nil
                                  "config" "get" "token"
                                  "--host" "gitlab.com")))
        (unless (eq status 0)
          (error "Cannot retrieve GitLab credential from glab"))
        (let ((token (string-trim (buffer-string))))
          (when (string-empty-p token)
            (error "glab has no stored token for gitlab.com"))
          token))))

  (cl-defun my/gitlab-forge-auth-search
      (&key host user port max &allow-other-keys)
    "Supply glab credentials only for this GitLab Forge account."
    (when (and (member host '("gitlab.com" "gitlab.com/api/v4"))
               (equal user "richardrh^forge")
               (or (null max) (> max 0)))
      (list (list :host host :user user :port port
                  :secret #'my/gitlab-forge-secret))))

  (defun my/gitlab-forge-auth-backend (entry)
    "Recognize the dedicated glab auth-source ENTRY."
    (when (eq entry 'my/gitlab-forge)
      (auth-source-backend
       :source "glab:gitlab.com"
       :type 'my/gitlab-forge
       :search-function #'my/gitlab-forge-auth-search)))

  (add-hook 'auth-source-backend-parser-functions
            #'my/gitlab-forge-auth-backend)
  (add-to-list 'auth-sources 'my/gitlab-forge)
  (auth-source-forget-all-cached))

;; GitLab returned burst_traffic_per_user_free_plan (100 requests/minute).
;; Pace requests, including pagination, so a full Forge import can finish.
(after! ghub
  (defvar my/gitlab-last-request-time 0)

  (defun my/gitlab-pace-request (_payload req)
    "Keep GitLab.com requests at least one second apart."
    (when (equal (url-host (ghub--req-url req)) "gitlab.com")
      ;; Recheck after sleeping because process callbacks can run meanwhile.
      (while (< (- (float-time) my/gitlab-last-request-time) 1.0)
        (sleep-for (max 0.01 (- 1.0 (- (float-time)
                                      my/gitlab-last-request-time)))))
      (setq my/gitlab-last-request-time (float-time))))

  (advice-add 'ghub--retrieve :before #'my/gitlab-pace-request))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; SBCL uses SLY; its stepper dependency lives in ~/common-lisp/agnostic-lizard,
;; which ASDF discovers automatically (no Quicklisp startup required).
(setq! inferior-lisp-program
       (or (executable-find "sbcl")
           "sbcl"))
