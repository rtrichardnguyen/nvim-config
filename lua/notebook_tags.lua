local M = {}

function M.lookup(pattern, flags)
  local filename = vim.api.nvim_buf_get_name(0)
  local temporary = vim.fn.tempname() .. '.qmd'
  local ok, result = pcall(function()
    vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), temporary)
    return vim.system({
      '/opt/homebrew/bin/ctags', '--language-force=Quarto', '--extras=+g',
      '--output-format=json', '--fields=+n', '-f', '-', temporary,
    }, { text = true }):wait()
  end)
  vim.fn.delete(temporary)
  if not ok or result.code ~= 0 then
    error('Notebook tags: ' .. (ok and result.stderr or tostring(result)))
  end
  local matches = {}
  for line in result.stdout:gmatch('[^\n]+') do
    local tag = vim.json.decode(line)
    if tag._type == 'tag' and tag.line and (
      (flags:find('c', 1, true) and tag.name == pattern)
      or (not flags:find('c', 1, true) and vim.fn.match(tag.name, pattern) >= 0)
    ) then
      matches[#matches + 1] = {
        name = tag.name, filename = filename, cmd = tostring(tag.line), kind = tag.kind,
      }
    end
  end
  -- shortcut: index the active notebook only; use a project index for cross-notebook lookup.
  return #matches > 0 and matches or vim.NIL
end

function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('NotebookTags', { clear = true }),
    pattern = 'quarto',
    callback = function()
      if vim.api.nvim_buf_get_name(0):match('%.ipynb$') then
        vim.bo.tagfunc = "v:lua.require'notebook_tags'.lookup"
      end
    end,
  })
end

return M
