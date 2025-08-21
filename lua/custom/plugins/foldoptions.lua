-- Keymap to enable Treesitter folding in the current buffer
vim.keymap.set('n', 'zF', function()
  -- Set buffer-local folding options
  vim.opt_local.foldmethod = 'expr'
  vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.opt_local.foldlevel = 99 -- start folds open
  vim.opt_local.foldlevelstart = 99

  -- Optional: customize folded text display
  vim.opt_local.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g')
        \ .' ... ' . trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

  print 'Treesitter folding enabled for this buffer'
end, { desc = 'Enable Treesitter folding' })

return {}
