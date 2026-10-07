(require "vim-hx/init.scm")
(require "helix/keymaps.scm")

(set-vim-keybindings!)

(keymap (global)
        (normal (space (i ":lsp_or_syntax_symbol_picker")
                       (I ":lsp_or_syntax_workspace_symbol_picker"))))
