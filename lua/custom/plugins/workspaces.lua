return {
  {
    'natecraddock/workspaces.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' }, -- workspaces.nvim often integrates with Telescope
    config = function()
      require('workspaces').setup {
        -- Optional: Define your workspaces here
        -- workspaces = {
        --   { name = "MyProject", path = "~/dev/my_project" },
        --   { name = "AnotherProject", path = "~/code/another_project" },
        -- },
        -- Optional: Configure keymaps if desired
        -- keymaps = {
        --   open_picker = "<leader>wo",
        --   create_workspace = "<leader>wc",
        -- },
        --
      }
    end,
  },
}
