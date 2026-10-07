(require "vim-hx/init.scm")
(require "helix/keymaps.scm")

(set-vim-keybindings!)

(keymap (global)
        (normal (space (i ":imenu")
                       (I ":imenu-workspace"))))
