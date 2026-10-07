(require "vim-hx/init.scm")
(require "helix/keymaps.scm")

(set-vim-keybindings!)

(keymap (global)
        (normal (space (i ":lsp-or-syntax-symbol-picker")
                       (I ":lsp-or-syntax-workspace-symbol-picker"))))
