local M = {}

M.format = function(async, range)
    vim.lsp.buf.format({
        formatting_options = {
            trimTrailingWhitespace = true,
            insertFinalNewline = true,
            trimFinalNewlines = true,
        },
        async = async,
        range = range,
    })
end

local buffer_to_string = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    return table.concat(lines, '\n')
end

local run_diff = function()
    local diff_cmd = "cat << 'EOF' | diff -U 0 --color=never " ..
        vim.fn.expand("%:p") .. " -\n" .. buffer_to_string() .. "\nEOF"
    local handle = io.popen(diff_cmd)
    local result = handle:read("*a")
    if result == nil then
        print("Failed to read git diff output")
        handle:close()
        return nil
    end
    handle:close()

    return result
end

M.format_modified = function(async)
    local diff = run_diff()
    if diff == nil then
        return
    end

    local lines = vim.split(diff or '', '\n')

    for _, line in ipairs(lines) do
        if vim.startswith(line, '@@') == false then
            goto continue
        end

        local start_marker = line:find('+')
        if start_marker == nil then
            -- line only had deleted lines
            goto continue
        end

        local end_marker = line:find(' ', start_marker)
        if end_marker == nil then
            print('Misformatted line')
            goto continue
        end

        local subs = line:sub(start_marker + 1, end_marker - 1)

        local sep_marker = subs:find(',')
        if sep_marker == nil then
            sep_marker = end_marker
        end

        local start_line = tonumber(subs:sub(1, sep_marker - 1))
        local end_line = tonumber(subs:sub(sep_marker + 1, end_marker - 1)) or 0

        -- format current range
        M.format(async, {
            ['start'] = { start_line, 0 },
            ['end'] = { start_line + end_line, 0 },
        })
        ::continue::
    end
end

M.on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

    local set_keymap = function(mode, lhs, rhs, desc, op)
        local full_opts = op
        full_opts['desc'] = desc

        vim.keymap.set(mode, lhs, rhs, full_opts)
    end

    set_keymap('n', 'K', vim.lsp.buf.hover, 'Hover information', opts)
    set_keymap('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration', opts)
    set_keymap('n', 'gd', vim.lsp.buf.definition, 'Go to definition', opts)
    set_keymap('n', 'gr', require('telescope.builtin').lsp_references, 'Go to reference', opts)
    set_keymap('n', '<Leader>gi', vim.lsp.buf.implementation, 'Go to implementation', opts)
    set_keymap('i', '<C-s>', vim.lsp.buf.signature_help, 'Signature help', opts)
    set_keymap('n', '<Leader>D', vim.lsp.buf.type_definition, 'Go to type definition', opts)
    set_keymap('n', '<Leader>rn', vim.lsp.buf.rename, 'Rename symbol under cursor', opts)
    set_keymap('n', '<Leader>ca', vim.lsp.buf.code_action, 'Code Action', opts)
    set_keymap({ 'n', 'v' }, '<Leader>fr', function() M.format(true) end, 'Format buffer', opts)
    set_keymap('n', '<Leader>fm', function() M.format_modified(true) end, 'Format modified lines in buffer', opts)
end


M.project_to_container = function()
    local nvim_lsp = require('lspconfig')
    local root_pattern = nvim_lsp.util.root_pattern('.git')

    local cwd = root_pattern(vim.fn.getcwd())

    -- If cwd is a repo, it takes precedence as the container name.
    if cwd ~= '' then
        return vim.fn.fnamemodify(cwd, ':t')
    end

    -- Turn the name of the current file into the name of an expected container, assuming that
    -- the container running/building this file is named the same as the basename of the project
    -- that the file is in
    --
    -- The name of the current buffer
    local bufname = vim.api.nvim_buf_get_name(0)

    -- Turned into a filename
    local filename = nvim_lsp.util.path.is_absolute(bufname) and bufname or
        nvim_lsp.util.path.join(vim.loop.cwd(), bufname)

    -- Then the directory of the project
    local project_dirname = root_pattern(filename) or nvim_lsp.util.path.dirname(filename)

    -- And finally perform what is essentially a `basename` on this directory
    return vim.fn.fnamemodify(nvim_lsp.util.find_git_ancestor(project_dirname), ':t')
end
return M
