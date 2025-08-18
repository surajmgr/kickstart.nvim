return {
  'rmagatti/auto-session',
  config = function()
    require('auto-session').setup {
      log_level = 'error', -- Only log errors to keep output clean
      auto_restore_enabled = true, -- Automatically restore sessions when opening Neovim in a known project directory
      auto_create_enabled = true, -- Automatically create sessions when entering a new project directory
      auto_save_enabled = true, -- Automatically save sessions on exit
      -- purge_after_minutes = 14400, -- Optional: Purge sessions older than 10 days (14400 minutes)
    }
  end,
}
