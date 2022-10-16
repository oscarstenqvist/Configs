call plug#begin()
Plug 'tanvirtin/monokai.nvim' "Monokai theme
Plug 'windwp/nvim-autopairs' "Autopairs
Plug 'akinsho/toggleterm.nvim' "ToggleTerm
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow' "Rainbowsyntax
Plug 'dense-analysis/ale'	"Syntax errors
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'ggandor/leap.nvim' "Press s then two letters where you want to leap
Plug 'tpope/vim-repeat'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
call plug#end()

set autoindent noexpandtab tabstop=4 shiftwidth=4
set splitbelow
set splitright
set termguicolors
"set guicursor=a:blinkwait1-blinkon500-blinkoff500
"highlight Normal guifg=Cyan
let g:ale_sign_column_always = 1
nnoremap <d-b> <cmd>NvimTreeToggle<cr>
nnoremap <d-v> "+p
nnoremap <d-c> "+y
xnoremap <d-v> "+p
xnoremap <d-c> "+y
tnoremap <c-w><c-w> <c-\><c-n><c-w><c-w>

if exists("g:neovide")
	let g:neovide_refresh_rate = 90
	let g:neovide_cursor_animation_length=0.1
	let g:neovide_cursor_vfx_mode = "wireframe"
endif
lua << EOF
vim.opt.guifont = {"RobotoMono NF", ":h17" }
vim.wo.number = true

require('monokai').setup { italics = false}

local custom_molokai= require'lualine.themes.molokai'
--custom_molokai.normal.c.bg = '#26292c'
custom_molokai.normal.c.bg = '#fd971f'
custom_molokai.normal.c.fg = '#000000'
require('lualine').setup{ options = { theme = custom_molokai}}
require('toggleterm').setup{size = 10, open_mapping=[[<d-j>]], shade_terminals = true, shading_factor = 1}
require('nvim-tree').setup()
require("nvim-autopairs").setup {}
require('leap').add_default_mappings()
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	rainbow = {
		enable = true,
		colors = {"#00ff00", "#00ffff", "#ff8000", "#ff00ff", "#ffff00",
				"#00ff00", "#00ffff", "#ff8000", "#ff00ff", "#ffff00",
				"#00ff00", "#00ffff", "#ff8000", "#ff00ff", "#ffff00",
				"#00ff00", "#00ffff", "#ff8000", "#ff00ff", "#ffff00"},
		extended_mode = false, 
		max_file_lines = nil,
	}
}

local has_words_before = function()
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
