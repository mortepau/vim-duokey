# vim-duokey

When your native language isn't English (specifically American) your keyboard layout will probably not be the best in combination with
the original Vim keybindings. This plugin makes it easier to use them by allowing two keyboard layouts based on which mode you are in.

## Prerequisites

For this plugin to function properly the events FocusGained and FocusLost has to trigger properly.
This works out of the box for gui based Vim/Neovim, but needs some setup in terminal.

If you are using [Tmux](https://github.com/tmux/tmux) and the FocusLost and FocusGained events doesn't trigger
you can use the plugin [tmux-plugins/vim-tmux-focus-events](https://github.com/tmux-plugins/vim-tmux-focus-events) and follow
their instructions to make the events work properly.

## Installation

Install using your favorite package manager or use Vim's built-in package support.

Example using [Vim-Plug](https://github.com/junegunn/vim-plug)
``` vim
Plug 'mortepau/vim-duokey'
```

Vim:
``` sh
mkdir -p ~/.vim/pack/duokey/start
cd ~/.vim/pack/duokey/start
git clone https://github.com/mortepau/vim-duokey.git
vim -u NONE -c "helptags vim-duokey/doc" -c q
```

Neovim:
``` sh
mkdir -p ~/.config/nvim/pack/duokey/start
cd ~/.config/nvim/pack/duokey/start
git clone https://github.com/mortepau/vim-duokey.git
nvim -u NONE -c "helptags vim-duokey/doc" -c q
```

## Configuration

There are three things to consider when utilizing this plugin:
1. Which keyboard configuration tool to use. (`g:duokey_program`)
2. Primary language (System layout). (`g:duokey_primary`)
3. Secondary language (Layout to use in Normal/Visual/Select mode). (`g:duokey_secondary`)

The plugin tries to set a default configuration for each system, but will fail
if the system will fail if the tool isn't installed. An error will be generated
if it cannot find the executable.

### A simple example

A small example showcasing how to setup `vim-duokey`.
This sets it up to use `setxkbmap` as the layout changer and switches between 
the `no` (Norwegian) and `us` (American) keyboard layouts.
``` vim
let g:duokey_program = 'setxkbmap'
let g:duokey_primary = 'no'
let g:duokey_secondary = 'us'
```

### Adding indicator to statusline

By using the `DuoKeyLayoutChange` event triggered whenever the layout is
changed and by using the function `DuoKeyCurrentLayout` it
is possible to add an indicator to your statusline for which layout
that is currently in use.

``` vim
" Returns the current keyboard layout in uppercase
function! StatuslineKeyboard() abort
    if g:duokey_enable
        return toupper(DuoKeyCurrentLayout())
    endif
    return ''
endfunction 

" If you are using lightline and StatuslineKeyboard is in the 
" component_function list of lightline
autocmd User DuoKeyLayoutChange call lightline#update()
```

## Licence
[MIT](https://github.com/mortepau/vim-duokey/blob/master/LICENSE)
