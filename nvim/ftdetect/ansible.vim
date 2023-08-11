au BufRead,BufNewFile */ansible/*.yml setlocal ft=yaml.ansible
au BufRead,BufNewFile */ansible/*.yaml setlocal ft=yaml.ansible

" Following autocommands taken from https://github.com/mfussenegger/nvim-ansible
au BufRead,BufNewFile */playbooks/*.yml setlocal ft=yaml.ansible
au BufRead,BufNewFile */playbooks/*.yaml setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/tasks/*.yml setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/tasks/*.yaml setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/handlers/*.yml setlocal ft=yaml.ansible
au BufRead,BufNewFile */roles/*/handlers/*.yaml setlocal ft=yaml.ansible
