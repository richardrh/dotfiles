;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

(doom! :completion
       (corfu +orderless)
       vertico

       :ui
       doom
       dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       snippets
       (whitespace +guess +trim)

       :emacs
       dired
       electric
       tramp
       undo
       vc

       :checkers
       (syntax +flymake)

       :tools
       (eval +overlay)
       lookup
       (lsp +eglot)
       magit
       tree-sitter

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       (clojure +lsp +tree-sitter)
       common-lisp
       (csharp +lsp +tree-sitter)
       (dart +lsp +tree-sitter)
       emacs-lisp
       (go +lsp +tree-sitter)
       (java +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (kotlin +lsp +tree-sitter)
       markdown
       org
       (python +lsp +tree-sitter)
       (rust +lsp +tree-sitter)
       sh

       :config
       (default +bindings +smartparens))
