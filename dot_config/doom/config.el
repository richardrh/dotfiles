;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-theme 'doom-one
      display-line-numbers-type t
      org-directory "~/org/"
      imenu-auto-rescan t
      treesit-auto-install-grammar 'always)

;; Doom's archived Dart grammar fork is incompatible with dart-ts-mode.
(after! treesit
  (setf (alist-get 'dart treesit-language-source-alist)
        '("https://github.com/UserNobody14/tree-sitter-dart")))

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

;; Navigate Dired like a normal Evil buffer.
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
