:set number relativenumber
:set nu rnu
:set cursorline

let b:ale_fixers = ['prettier']
autocmd BufNewFile,BufRead *.yml :ALEToggle | ALEToggle


