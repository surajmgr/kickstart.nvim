local map = vim.keymap.set

-- Workspace commands
map('n', '<leader>Ww', ':Telescope workspaces<CR>', { desc = '[W]orkspaces [S]earch' })
map('n', '<leader>Wa', ':WorkspacesAdd<CR>', { desc = '[W]orkspace [A]dd' })
map('n', '<leader>Wr', ':WorkspacesRemove<CR>', { desc = '[W]orkspace [R]emove' })
map('n', '<leader>Wo', ':WorkspacesOpen<CR>', { desc = '[W]orkspace [O]pen' })
map('n', '<leader>Wl', ':WorkspacesList<CR>', { desc = '[W]orkspace [L]ist' })
map('n', '<leader>Wd', ':WorkspacesListDirs<CR>', { desc = '[W]orkspace List [D]irs' })
map('n', '<leader>Ws', ':WorkspacesSyncDirs<CR>', { desc = '[W]orkspace [S]ync' })
map('n', '<leader>Wn', ':WorkspacesRename<CR>', { desc = '[W]orkspace Re[N]ame' })

-- Session commands
map('n', '<leader>Ss', ':SessionSave<CR>', { desc = '[S]ession [S]ave' })
map('n', '<leader>Sr', ':SessionRestore<CR>', { desc = '[S]ession [R]estore' })
map('n', '<leader>Sd', ':SessionDelete<CR>', { desc = '[S]ession [D]elete' })
map('n', '<leader>St', ':SessionToggleAutoSave<CR>', { desc = '[S]ession [T]oggle Autosave' })
map('n', '<leader>Sp', ':SessionPurgeOrphaned<CR>', { desc = '[S]ession [P]urge Orphaned' })
map('n', '<leader>Sa', ':SessionSearch<CR>', { desc = '[S]ession [A]ll Search Picker' })

-- Noice commands
map('n', '<leader>nd', ':NoiceDismiss<CR>', { desc = '[N]oise [D]ismiss' })
map('n', '<leader>nD', ':NoiceDismissAll<CR>', { desc = '[N]oise [D]ismiss [A]ll' })
map('n', '<leader>nS', ':NoiceToggle<CR>', { desc = '[N]oise [S]tatus' })
map('n', '<leader>nH', ':NoiceHistory<CR>', { desc = '[N]oise [H]istory' })

return {}
