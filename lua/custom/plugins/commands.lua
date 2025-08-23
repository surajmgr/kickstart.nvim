local create_user_command = vim.api.nvim_create_user_command

-- For mistypes of common commands
create_user_command('W', 'w', { desc = 'Write file' })
create_user_command('Q', 'q', { desc = 'Quit' })
create_user_command('Wq', 'wq', { desc = 'Write and Quit' })
create_user_command('WQ', 'wq', { desc = 'Write and Quit' })
create_user_command('Qa', 'qa', { desc = 'Quit all' })
create_user_command('QA', 'qa', { desc = 'Quit all' })
create_user_command('Wqa', 'wqa', { desc = 'Write and Quit all' })
create_user_command('WQA', 'wqa', { desc = 'Write and Quit all' })

-- Shortened/alias commands
create_user_command('BufOnly', ':%bd|e#', { desc = 'Close all buffers except the current one' })

return {}
