" Minimal Tokyo Night-inspired colorscheme.
hi clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'tokyonight'

hi Normal       guifg=#c0caf5 guibg=#1a1b26 ctermfg=153 ctermbg=235
hi Cursor       guifg=#1a1b26 guibg=#c0caf5 ctermfg=235 ctermbg=153
hi CursorLine   guibg=#202330 ctermbg=236
hi LineNr       guifg=#565f89 ctermfg=60
hi CursorLineNr guifg=#7aa2f7 gui=bold ctermfg=111 cterm=bold
hi SignColumn   guibg=#1a1b26 ctermbg=235
hi Visual       guibg=#33467c ctermbg=60
hi Search       guifg=#1a1b26 guibg=#e0af68 ctermfg=235 ctermbg=179
hi IncSearch    guifg=#1a1b26 guibg=#7dcfff ctermfg=235 ctermbg=81
hi StatusLine   guifg=#c0caf5 guibg=#24283b ctermfg=153 ctermbg=236
hi StatusLineNC guifg=#565f89 guibg=#1f2335 ctermfg=60 ctermbg=235
hi Comment      guifg=#565f89 ctermfg=60
hi Constant     guifg=#ff9e64 ctermfg=215
hi String       guifg=#9ece6a ctermfg=113
hi Character    guifg=#9ece6a ctermfg=113
hi Number       guifg=#ff9e64 ctermfg=215
hi Boolean      guifg=#bb9af7 ctermfg=141
hi Identifier   guifg=#c0caf5 ctermfg=153
hi Function     guifg=#7aa2f7 ctermfg=111
hi Statement    guifg=#bb9af7 ctermfg=141
hi Keyword     guifg=#bb9af7 ctermfg=141
hi Type        guifg=#2ac3de ctermfg=80
hi Special     guifg=#7dcfff ctermfg=81
hi PreProc     guifg=#bb9af7 ctermfg=141
hi Error       guifg=#f7768e guibg=#1a1b26 ctermfg=203 ctermbg=235
hi Todo        guifg=#1a1b26 guibg=#e0af68 ctermfg=235 ctermbg=179
