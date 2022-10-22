call plug#begin()
Plug 'sonph/onehalf', {'rtp': 'vim/'} "Theme
Plug 'nvim-tree/nvim-tree.lua' "File explorer cmd-b
Plug 'lukas-reineke/indent-blankline.nvim' "Indentlines
Plug 'windwp/nvim-autopairs' "Autoadds pairs for {}()[]
Plug 'akinsho/toggleterm.nvim' "ToggleTerm with cmd-j
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} "Syntax highlight
Plug 'p00f/nvim-ts-rainbow' "Rainbow {}()[]
Plug 'nvim-lualine/lualine.nvim' "Bottom bar
Plug 'nvim-tree/nvim-web-devicons' "File icons Plug 'nvim-tree/nvim-tree.lua'
Plug 'ggandor/leap.nvim' "Leap to word with s-L1L2 or S-L1L2
Plug 'ray-x/lsp_signature.nvim' "Show arguments for functions
Plug 'neovim/nvim-lspconfig' "Error and completion
Plug 'hrsh7th/cmp-nvim-lsp' "Autocomplete with Tab
Plug 'hrsh7th/cmp-buffer' "Req for cmp
Plug 'hrsh7th/cmp-path' "Req for cmp
Plug 'hrsh7th/cmp-cmdline' "Req for cmp
Plug 'hrsh7th/nvim-cmp' "Req for cmp
Plug 'hrsh7th/cmp-vsnip' "Req for cmp
Plug 'hrsh7th/vim-vsnip' "Req for cmp
Plug 'hrsh7th/vim-vsnip-integ' "Req for cmp
Plug 'tpope/vim-repeat' "Req for cmp
call plug#end()

colorscheme onehalfdark
set autoindent noexpandtab tabstop=4 shiftwidth=4 "Indent to 4
set splitbelow splitright "Split vertical right and horizontal below
set termguicolors "Enable colors
set signcolumn=yes "Always show error column
set cmdheight=0 "Hide commandline under lualine
hi MatchParen guifg=black guibg=#fd971f
hi Pmenu guifg=#dcdfe4 guibg=#373d48
hi PmenuSel guifg=#dcdfe4 guibg=#21252b
hi PmenuThumb guibg=#21252b

nnoremap <d-b> <cmd>NvimTreeToggle<cr>
nnoremap <d-v> "+p
nnoremap <d-c> "+y
xnoremap <d-v> "+p
xnoremap <d-c> "+y
inoremap <d-v> <C-R>*
tnoremap <c-w><c-w> <c-\><c-n><c-w><c-w>

if exists("g:neovide") "Neovide settings
	let g:neovide_refresh_rate=999
	let g:neovide_cursor_animation_length=0.1
	let g:neovide_cursor_vfx_mode = "wireframe"
	let g:neovide_floating_opacity = 1
endif

lua << EOF
vim.opt.guifont = {"RobotoMono NF", ":h17" } --Font and fontsize
vim.wo.number = true --Linenumbers

local lualine_custom= require'lualine.themes.ayu_dark' --Bottombar custom molokai theme
lualine_custom.normal.c.bg = '#FF7F00'--'#fd971f'
lualine_custom.normal.c.fg = '#000000'
--require('lualine').setup{ options = { theme = custom_molokai}}
require('lualine').setup{ options = { theme = lualine_custom}}

require('toggleterm').setup{size = 10, open_mapping=[[<d-j>]]}
require('nvim-tree').setup()
require("nvim-autopairs").setup {}
vim.diagnostic.config({virtual_text = false})--Disable error line in buffer
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
require'lspconfig'.pyright.setup{}--Python error and completion
require'lspconfig'.clangd.setup{}--c/c++ error and completion
require'lspconfig'.sumneko_lua.setup{}
require('leap').add_default_mappings()
require "lsp_signature".setup{ hint_enable = false}
require("indent_blankline").setup {}
require'nvim-treesitter.configs'.setup { --Syntax highlight and rainbow brackets
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
		colors = { "#FF00FF", "#FFFF00", "#FF7F00"
		}
	}
}

local has_words_before = function() --autocomplete with tab and shit-tab
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local cmp = require'cmp'
cmp.setup({
	snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
    },
	mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
})
EOF
