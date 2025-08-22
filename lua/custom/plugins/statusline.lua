local statusline = require 'mini.statusline'

-- Enhanced color palette with better split separators
vim.api.nvim_set_hl(0, 'MiniStatuslineSaved', { fg = '#10B981', bg = 'NONE', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineModified', { fg = '#F59E0B', bg = 'NONE', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { fg = '#6B7280', bg = 'NONE', italic = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = '#1F2937', bg = '#E5E7EB', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = '#FFFFFF', bg = '#059669', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = '#FFFFFF', bg = '#7C3AED', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { fg = '#FFFFFF', bg = '#DC2626', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { fg = '#1F2937', bg = '#FCD34D', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { fg = '#FFFFFF', bg = '#4B5563', bold = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = '#6B7280', bg = 'NONE', italic = false })
vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = '#374151', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = '#9CA3AF', bg = 'NONE' })

-- Buffer status popup highlight groups
vim.api.nvim_set_hl(0, 'BufferStatusSaved', { fg = '#10B981', bg = '#F3F4F6', bold = true })
vim.api.nvim_set_hl(0, 'BufferStatusModified', { fg = '#DC2626', bg = '#F3F4F6', bold = true })
vim.api.nvim_set_hl(0, 'BufferStatusReadonly', { fg = '#6366F1', bg = '#F3F4F6', bold = true })
vim.api.nvim_set_hl(0, 'BufferStatusHeader', { fg = '#1F2937', bg = '#E5E7EB', bold = true })
vim.api.nvim_set_hl(0, 'BufferStatusBorder', { fg = '#9CA3AF', bg = 'NONE' })

-- Striking split window separators
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#4B5563', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'VertSplit', { fg = '#4B5563', bg = 'NONE', bold = true })
vim.opt.fillchars = {
  vert = '┃', -- Vertical split
  horiz = '━', -- Horizontal split
  horizup = '┻', -- Horizontal up
  horizdown = '┳', -- Horizontal down
  vertleft = '┫', -- Vertical left
  vertright = '┣', -- Vertical right
  verthoriz = '╋', -- Cross
  stl = '─', -- Statusline fill
  stlnc = '─', -- Inactive statusline fill
}

-- Minimalistic mode indicator
local function section_mode(args)
  local mode_map = {
    ['n'] = 'NOR',
    ['i'] = 'INS',
    ['v'] = 'VIS',
    ['V'] = 'VLN',
    ['\22'] = 'VBL',
    ['c'] = 'CMD',
    ['R'] = 'REP',
    ['t'] = 'TER',
    ['!'] = 'SHL',
  }
  local mode = vim.fn.mode()
  local mode_str = mode_map[mode] or 'UNK'
  local hl_map = {
    ['n'] = 'Normal',
    ['i'] = 'Insert',
    ['v'] = 'Visual',
    ['V'] = 'Visual',
    ['\22'] = 'Visual',
    ['c'] = 'Command',
    ['R'] = 'Replace',
    ['t'] = 'Other',
    ['!'] = 'Other',
  }
  local hl = 'MiniStatuslineMode' .. (hl_map[mode] or 'Other')
  return ' ' .. mode_str .. ' ', hl
end

-- Clean file status with better symbols - modified to work with specific buffer
local function section_file_status_for_buffer(bufnr, args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end

  -- Use provided buffer or current buffer
  local buf = bufnr or vim.api.nvim_get_current_buf()

  if vim.bo[buf].readonly then
    return '%#MiniStatuslineDevinfo# [RO]%*'
  end
  local status = vim.bo[buf].modified and ' ●' or ''
  local hl = vim.bo[buf].modified and 'MiniStatuslineModified' or 'MiniStatuslineSaved'
  return status ~= '' and ('%#' .. hl .. '#' .. status .. '%*') or ''
end

-- Regular file status for current buffer
local function section_file_status(args)
  return section_file_status_for_buffer(nil, args)
end

-- Clean git section
local function section_git(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end
  local git = MiniStatusline.section_git { icon = '' }
  return git ~= '' and ('⎇ ' .. git) or ''
end

-- Minimal diagnostics
local function section_diagnostics(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end
  local signs = { ERROR = 'E', WARN = 'W', INFO = 'I', HINT = 'H' }
  local diag = MiniStatusline.section_diagnostics { signs = signs, icon = '' }
  return diag ~= '' and ('◆ ' .. diag) or ''
end

-- Enhanced LSP section
local function section_lsp(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end
  local lsp = MiniStatusline.section_lsp { icon = '' }
  return lsp ~= '' and ('◉ ' .. lsp) or ''
end

-- Clean search count
local function section_search(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end
  local search = MiniStatusline.section_searchcount { options = { recompute = false } }
  return search ~= '' and ('/' .. search) or ''
end

-- Simplified location (line:col only, no totals)
local function section_location_simple(args)
  if MiniStatusline.is_truncated(args.trunc_width) then
    return ''
  end
  local line = vim.fn.line '.'
  local col = vim.fn.col '.'
  return string.format('%d:%d', line, col)
end

-- Winbar content for individual windows - shows unsaved state for specific buffer
local function winbar_content_for_buffer(bufnr, is_active)
  local buf = bufnr or vim.api.nvim_get_current_buf()

  -- Get filename for specific buffer
  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then
    name = '[No Name]'
  else
    name = vim.fn.fnamemodify(name, ':t') -- Just filename
  end

  -- Get file status for specific buffer
  local file_status = section_file_status_for_buffer(buf, { trunc_width = 80 })
  local git = section_git { trunc_width = 40 }

  -- Use different highlighting based on active state
  local filename_hl = is_active and 'MiniStatuslineFilename' or 'MiniStatuslineInactive'
  local git_hl = is_active and 'MiniStatuslineDevinfo' or 'MiniStatuslineInactive'

  return MiniStatusline.combine_groups {
    { hl = filename_hl, strings = { ' ' .. name } },
    { hl = 'MiniStatuslineModified', strings = { file_status } }, -- Always use modified color for visibility
    '%=', -- Right align
    { hl = git_hl, strings = { git } },
    ' ', -- Small padding at the end
  }
end

-- Global functions for winbar
function _G.StatuslineWinbarActive()
  local bufnr = vim.api.nvim_win_get_buf(0)
  return winbar_content_for_buffer(bufnr, true)
end

function _G.StatuslineWinbarInactive()
  local bufnr = vim.api.nvim_win_get_buf(0)
  return winbar_content_for_buffer(bufnr, false)
end

-- Buffer status functionality (unchanged)
local function get_buffer_status()
  local buffers = {}
  local current_buf = vim.api.nvim_get_current_buf()

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name == '' then
        name = '[No Name]'
      else
        name = vim.fn.fnamemodify(name, ':t') -- Just filename
      end

      local status = 'saved'
      local icon = '✓'
      local hl = 'BufferStatusSaved'

      if vim.bo[buf].modified then
        status = 'modified'
        icon = '●'
        hl = 'BufferStatusModified'
      elseif vim.bo[buf].readonly then
        status = 'readonly'
        icon = '🔒'
        hl = 'BufferStatusReadonly'
      end

      table.insert(buffers, {
        buf = buf,
        name = name,
        status = status,
        icon = icon,
        hl = hl,
        is_current = buf == current_buf,
      })
    end
  end

  return buffers
end

local function show_buffer_status()
  local buffers = get_buffer_status()
  if #buffers == 0 then
    return
  end

  -- Calculate window dimensions
  local saved_count = 0
  local modified_count = 0
  local readonly_count = 0
  local max_name_length = 0

  for _, buf in ipairs(buffers) do
    max_name_length = math.max(max_name_length, #buf.name)
    if buf.status == 'saved' then
      saved_count = saved_count + 1
    elseif buf.status == 'modified' then
      modified_count = modified_count + 1
    elseif buf.status == 'readonly' then
      readonly_count = readonly_count + 1
    end
  end

  local width = math.min(math.max(max_name_length + 15, 40), 80)
  local height = math.min(#buffers + 4, 20) -- +4 for header and summary

  -- Create buffer content
  local lines = {}
  local highlights = {}

  -- Header
  table.insert(lines, ' Buffer Status Overview ')
  table.insert(highlights, { line = 0, col_start = 0, col_end = -1, hl_group = 'BufferStatusHeader' })

  -- Summary
  local summary = string.format(' %d saved • %d modified • %d readonly ', saved_count, modified_count, readonly_count)
  table.insert(lines, summary)
  table.insert(highlights, { line = 1, col_start = 0, col_end = -1, hl_group = 'BufferStatusHeader' })

  -- Separator
  table.insert(lines, string.rep('─', width - 2))

  -- Buffer list
  for i, buf in ipairs(buffers) do
    local current_marker = buf.is_current and '► ' or '  '
    local line = string.format('%s%s %s', current_marker, buf.icon, buf.name)
    table.insert(lines, line)

    -- Highlight the icon
    local icon_start = #current_marker
    table.insert(highlights, {
      line = i + 2,
      col_start = icon_start,
      col_end = icon_start + #buf.icon,
      hl_group = buf.hl,
    })

    -- Highlight current buffer line
    if buf.is_current then
      table.insert(highlights, {
        line = i + 2,
        col_start = 0,
        col_end = 2,
        hl_group = 'BufferStatusHeader',
      })
    end
  end

  -- Create floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = 'minimal',
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    title = ' Buffers ',
    title_pos = 'center',
  })

  -- Apply highlights
  local ns = vim.api.nvim_create_namespace 'buffer_status'
  for _, hl in ipairs(highlights) do
    vim.api.nvim_buf_add_highlight(buf, ns, hl.hl_group, hl.line, hl.col_start, hl.col_end)
  end

  -- Set window highlight
  vim.api.nvim_win_set_option(win, 'winhighlight', 'Normal:BufferStatusSaved,FloatBorder:BufferStatusBorder')

  -- Auto-close on various events
  local close_events = { 'BufLeave', 'CursorMoved', 'CursorMovedI', 'InsertEnter' }
  local group = vim.api.nvim_create_augroup('BufferStatusFloat', { clear = true })

  for _, event in ipairs(close_events) do
    vim.api.nvim_create_autocmd(event, {
      group = group,
      callback = function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
        vim.api.nvim_del_augroup_by_id(group)
      end,
    })
  end

  -- Close on any key press
  vim.defer_fn(function()
    if vim.api.nvim_win_is_valid(win) then
      vim.keymap.set('n', '<Esc>', function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_del_augroup_by_id(group)
      end, { buffer = buf, nowait = true })
      vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_del_augroup_by_id(group)
      end, { buffer = buf, nowait = true })

      -- Auto-close after 5 seconds
      vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
          vim.api.nvim_del_augroup_by_id(group)
        end
      end, 5000)
    end
  end, 100)
end

statusline.setup {
  use_icons = vim.g.have_nerd_font or false,
  content = {
    -- Global statusline at bottom with straight line design
    active = function()
      local mode, mode_hl = section_mode { trunc_width = 100 }
      local git = section_git { trunc_width = 60 }
      local diagnostics = section_diagnostics { trunc_width = 80 }
      local lsp = section_lsp { trunc_width = 70 }
      local filename = MiniStatusline.section_filename { trunc_width = 120 }
      local search = section_search { trunc_width = 60 }
      local location = section_location_simple { trunc_width = 60 }

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics, lsp, search } },
        '%=', -- Right align - creates the straight line effect
        { hl = mode_hl, strings = { location } },
      }
    end,

    inactive = function()
      local filename = MiniStatusline.section_filename { trunc_width = 120 }
      return MiniStatusline.combine_groups {
        { hl = 'MiniStatuslineInactive', strings = { ' ' .. filename .. ' ' } },
      }
    end,
  },
}

-- Set up global statusline at bottom
vim.opt.laststatus = 3 -- Global statusline

-- Set up winbar for individual windows at top
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'VimEnter' }, {
  callback = function()
    -- Only set winbar for normal buffers
    if vim.bo.buftype == '' or vim.bo.buftype == 'acwrite' then
      vim.wo.winbar = '%{%v:lua.StatuslineWinbarActive()%}'
    else
      vim.wo.winbar = ''
    end
  end,
})

vim.api.nvim_create_autocmd({ 'WinLeave' }, {
  callback = function()
    if vim.bo.buftype == '' or vim.bo.buftype == 'acwrite' then
      vim.wo.winbar = '%{%v:lua.StatuslineWinbarInactive()%}'
    end
  end,
})

-- Update winbar when buffer is modified
vim.api.nvim_create_autocmd({ 'BufModifiedSet', 'TextChanged', 'TextChangedI' }, {
  callback = function()
    if vim.bo.buftype == '' or vim.bo.buftype == 'acwrite' then
      -- Force winbar refresh
      local current_win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_is_valid(current_win) then
        vim.wo[current_win].winbar = '%{%v:lua.StatuslineWinbarActive()%}'
      end
    end
  end,
})

-- Key mapping for buffer status (Leader + b + s)
vim.keymap.set('n', '<leader>bs', show_buffer_status, {
  desc = 'Show buffer save status',
  silent = true,
})

-- Alternative key mapping (Ctrl + Shift + B)
vim.keymap.set('n', '<C-S-b>', show_buffer_status, {
  desc = 'Show buffer save status',
  silent = true,
})

-- Don't return anything to avoid plugin manager errors
return {}
