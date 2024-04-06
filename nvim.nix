{
# https://github.com/nvim-treesitter/nvim-treesitter-textobjects
# [ ] make settings for vim.diagnostic.goto_next() and vim.diagnostic.goto_prev()
  luaCustomTreesitterKeys = ''
    --local queries = require('nvim-treesitter.query')  
    --local ts_utils = require('nvim-treesitter.ts_utils')
    
    require'nvim-treesitter.configs'.setup {
      textobjects = {
        select = {
          enable = true,
    
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
    
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["gg"] = "@function.outer",
            ["ff"] = "@function.inner",
            ["ac"] = "@class.outer",
            -- You can optionally set descriptions to the mappings (used in the desc parameter of
            -- nvim_buf_set_keymap) which plugins like which-key display
            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            -- You can also use captures from other query groups like `locals.scm`
            ["fg"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
          },
          -- You can choose the select mode (default is charwise 'v')
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * method: eg 'v' or 'o'
          -- and should return the mode ('v', 'V', or '<c-v>') or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = '<c-v>', -- blockwise
          },
          -- If you set this to `true` (default is `false`) then any textobject is
          -- extended to include preceding or succeeding whitespace. Succeeding
          -- whitespace has priority in order to act similarly to eg the built-in
          -- `ap`.
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg '@function.inner'
          -- * selection_mode: eg 'v'
          -- and should return true or false
          --include_surrounding_whitespace = true,
        },
      },
    }

    -- get node under cursor
    require'nvim-treesitter.configs'.setup {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "fff", -- set to `false` to disable one of the mappings
          node_incremental = "f..",
          scope_incremental = "f--",
          node_decremental = "f,,",
        },
      },
    }
  '';
  # lets list our custom key mappings
  # docfiles dont work for me atm 
  luaCustomHelp = ''
    function ShowCustomHelp()
      local help_content = [[
        Coding Keys             
        |:Q| -> exit help page  (or |:bd!| closing buffer)
        =========================================================
        Code Acions Nvim
        |#d| -> Declaration
        |#D| -> Definition      
        |#h| -> Singature Help
        |#H| -> Hover
        |#i| -> Implementation
        |#r| -> References
        |#+| -> Rename
        |#a| -> Code Action // dang doubled now need to rebind
        |#f| -> Format
        
        |#a| -> next error / warning
        |#q| -> prev error / warning
        |#L| -> LspInfo


        Basic nvim
        |.| to repeat copy paste
        |vaw, viw| other and inner word selection
        |^, $| start and end of text in line (regex)
        |%| jump braces () {}

        Nodeselection
        |fff| current node
        |f..| increase
        |f,,| decrease
        |f--| scope
        |:Inspect|, |:Inspectree|


        Tmux defaults
        |<cmd>"| split horizontal       window
        |<cmd>%| split vertical         window
        |<cmd><arrowKey>| navigation between windows    left, right, up ,down
        |[hold]<cmd> + <arrowKey>| increase decrease splitscreen
  
      ]]
      -- Display the help content in a new buffer
      vim.api.nvim_command('enew') -- Open a new buffer
      vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.split(help_content, '\n')) -- Set the lines in the buffer
      vim.api.nvim_buf_set_option(0, 'filetype', 'help') -- Set the filetype to 'help' for proper highlighting
      vim.api.nvim_win_set_option(0, 'wrap', true) -- Enable wrapping for long lines
    
      -- Close the current buffer
      vim.api.nvim_command('command! -buffer Q bd!')
    end

    -- Define a command to call the Lua function
    vim.cmd('command! Coding lua ShowCustomHelp()')
  '';

  luaRC = '' 
    vim.g.mapleader = "#"
    vim.g.maplocalleader = "#"

    local lspconfig = require('lspconfig')
    local cmp_nvim_lsp = require('cmp_nvim_lsp')

    cmp_nvim_lsp.setup({})

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    local completion_capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

    local on_attach = function(client, bufnr)
      -- missed opts, stupid me
      local opts = { noremap = true, silent = true }
      if client.server_capabilities.documentHighlightProvider then
         vim.cmd [[
           hi! LspReferenceRead cterm=bold ctermbg=235 guibg=LightYellow
           hi! LspReferenceText cterm=bold ctermbg=235 guibg=LightYellow
           hi! LspReferenceWrite cterm=bold ctermbg=235 guibg=LightYellow
         ]]
         vim.api.nvim_create_augroup('lsp_document_highlight', {})
         vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
           group = 'lsp_document_highlight',
           buffer = 0,
           callback = vim.lsp.buf.document_highlight,
         })
         vim.api.nvim_create_autocmd('CursorMoved', {
           group = 'lsp_document_highlight',
           buffer = 0,
           callback = vim.lsp.buf.clear_references,
         })
        end

	if client.server_capabilities.documentSymbolProvider then
        -- LSP KEYS
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
        end

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>D', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>H', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>+', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader><Leader>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>f', '<cmd>lua vim.lsp.buf.format({async=true})<CR>', opts)
          -- OTHER KEYS
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>L', '<cmd>LspInfo<CR>', opts)
          -- next and prev message
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>a', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>q', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

    end

    local servers = { 'rust_analyzer', 'nil_ls' }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end     

  '';

  neovimRC = ''
    set number
    set expandtab
    set shiftwidth=2
    set encoding=utf-8
    colorscheme tokyonight

    " press jj to exit in insert mode  
    inoremap jj <Esc>
    
    " ease window split navigation
    " use ctrl + h,j,k,l
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

    "load custom docs
    " does not work on nixos, atleast for me atm
    "autocmd BufWritePost ~/.vim/doc/* :helptags ~/.vim/doc
  '';
}

