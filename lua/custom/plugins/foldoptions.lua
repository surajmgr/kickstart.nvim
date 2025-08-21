-- Keymap to toggle Treesitter folding in the current buffer
vim.keymap.set('n', 'zF', function()
  local method = vim.opt_local.foldmethod:get()

  if method == 'expr' then
    -- Switch to manual so folds can be deleted
    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.foldexpr = ''
    print 'Switched to manual folding (can delete folds now)'
  else
    -- Switch to Treesitter expression folding
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldlevelstart = 99
    vim.opt_local.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g')
          \ .' ... ' . trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
    print 'Treesitter folding enabled for this buffer'
  end
end, { desc = 'Toggle Treesitter/manual folding' })

return {}
