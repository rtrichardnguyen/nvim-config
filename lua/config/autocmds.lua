-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.cmd([[
  augroup KeepCentered
    autocmd!
    autocmd CursorMoved * normal! zz
    autocmd TextChangedI * call InsertRecenter()
  augroup END

  function! InsertRecenter() abort
    let at_end = getcursorcharpos()[2] > len(getline('.'))
    normal! zz
    if at_end
      let cursor_pos = getcursorcharpos()
      let cursor_pos[2] += 1
      call setcursorcharpos(cursor_pos[1:])
    endif
  endfunction
]])
