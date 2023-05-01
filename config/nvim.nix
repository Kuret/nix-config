{ pkgs, lib, vimUtils, ... }:
let
  pluginGit = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };

  plugin = pluginGit "HEAD";
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      nodejs-16_x # Needed for copilot
    ];

    extraConfig = ''
      " Highlight text on yank
      au TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, timeout=1000}

      " Reload file when it changes on disk
      au FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
      au FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

      " Trim whitespace on save
      au BufWritePre * :%s/\s\+$//e
    '';

    extraLuaConfig = ''

      --          --
      -- Settings --
      --          --
      local o = vim.opt
      local fn = vim.fn
      local set = vim.keymap.set
      local indent = 2

      o.wildmode = 'longest,list,full'
      o.wildmenu = true
      o.omnifunc = 'syntaxcomplete#Complete'

      o.autowriteall = true -- Write all on exit
      o.clipboard = 'unnamedplus' -- Native clipboard
      o.completeopt = 'noinsert,menuone,noselect' -- Completion
      o.mouse = 'a' -- Mouse support
      o.shortmess = 'aoOTIcF' -- Disable welcome screen and other messages
      o.splitbelow = true -- New splits below current window
      o.splitright = true -- New splits right of current window
      o.sessionoptions = 'blank,curdir,help,tabpages,winsize' -- What to save/restore from sessions
      o.termguicolors = true -- Enable 24-bit RGB color support in the terminal
      o.undofile = true -- Save undo history across sessions

      o.tabstop = indent -- Amount of spaces to use for Tab
      o.shiftwidth = indent -- Amount of spaces to use for indentation
      o.expandtab = true -- Use spaces instead of tabs
      o.swapfile = false -- Don't use swapfile for buffers

      o.colorcolumn = '80,100' -- Show column at 80 and 100 chars
      o.cursorline = true -- Highlight current line
      o.fillchars = 'vert:│,eob: ' -- Full line separator for vsplits, No ~ for empty lines at end of buffer
      o.number = true -- Show line numbers
      o.relativenumber = true -- Show relative line numbers
      o.scrolloff = 2 -- Keep at least 2 lines above/below
      o.sidescrolloff = 2 -- Keep at least 2 columns left/right
      o.spell = true -- Enable spell checking
      o.statusline = '  %f:%l:%c  %m%=%{strlen(&ft)?&ft:"none"}  '
      o.laststatus = 3 -- Global statusline

      o.backup = false -- Don't create backup files
      o.writebackup = false -- Don't create backup files
      o.updatetime = 300 -- Faster completion
      o.signcolumn = 'yes' -- Always show signcolumn

      --          --
      -- Bindings --
      --          --
      vim.g.mapleader = " " -- Leader is space

      set('n', '<leader>o', 'o<Esc>') -- Newline without insert

      set('n', '<leader>cc', ':pclose<CR> <Bar> :cclose<CR>', {silent=true}) -- Close QuickFix and Preview windows
      set('n', '<leader>bn', ':bn<CR>', {silent=true}) -- Next buffer
      set('n', '<leader>bp', ':bp<CR>', {silent=true}) -- Previous buffer
      set('n', '<leader>\\', ':vnew<CR>', {silent=true}) -- Vertical split
      set('n', '<leader>-', ':new<CR>', {silent=true}) -- Horizontal split
      set('n', '<C-J>', '<C-W><C-J>') -- Navigation down
      set('n', '<C-K>', '<C-W><C-K>') -- Navigation up
      set('n', '<C-L>', '<C-W><C-L>') -- Navigation right
      set('n', '<C-H>', '<C-W><C-H>') -- Navigation left
      set('n', '<leader><Right>', ':tabn<CR>') -- Next tab
      set('n', '<leader><Left>', ':tabp<CR>') -- Previous tab
      set('n', '<leader><Down>', ':tabc<CR>') -- Close tab
      set('n', '<leader><Up>', ':tabnew<CR>') -- New tab
      set('n', '<leader>nh', ':noh<CR>', {silent=true}) -- Clear highlight
      set('n', '<leader>nw', [[:%s/\s\+$//<CR>]]) -- Trim trailing whitespace
      set('n', '<leader>x', ':Sexplore<CR>', {silent=true}) -- Open nvim's default explorer in split
      set('n', '<leader>q', ':wq<CR>', {silent=true}) -- Save and quit current buffer file
      set('i', 'jj', '<Esc>') -- Quickly leave insert mode

      -- Copilot --
      set('i', ']]', 'copilot#Next()', {silent=true, expr=true}) -- Copilot accept suggestion
      set('i', '[[', 'copilot#Previous()', {silent=true, expr=true}) -- Copilot accept suggestion

      -- Telescope --
      set('n', '<leader>p', ':Telescope resume<CR>', {silent=true})
      set('n', '<C-P>', ':Telescope find_files<CR>', {silent=true})
      set('n', '<leader>fg', ':Telescope live_grep<CR>', {silent=true})

      -- Vim-test --
      set('n', '<leader>tl', ':TestLast<CR>', {silent=true})
      set('n', '<leader>tt', ':TestNearest<CR>', {silent=true})
      set('n', '<leader>tf', ':TestFile<CR>', {silent=true})
      set('n', '<leader>ta', ':TestSuite<CR>', {silent=true})
      set('n', '<leader>tv', ':TestVisit<CR>', {silent=true})

      -- WinShift  --
      set('n', '<leader>ws', ':WinShift<CR>', {silent=true})
    '';

    plugins = with pkgs.vimPlugins; [
      # GitHub CoPilot
      {
        plugin = copilot-vim;
      	type = "lua";
      	config = ''
          vim.g.copilot_node_command = "${pkgs.nodejs-16_x}/bin/node"
      	'';
      }

      # Telescope
      plenary-nvim telescope-fzf-native-nvim
      {
        plugin = telescope-nvim;
      	type = "lua";
      	config = ''
      	  local actions = require('telescope.actions')

          require('telescope').setup {
            defaults = {
              mappings = {
                i = {
                  ["<esc>"] = actions.close
                }
              }
            },
            extensions = {
              fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = false, -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                                 -- the default case_mode is "smart_case"
              }
            }
          }

          require('telescope').load_extension('fzf')
      	'';
      }

      # Language support
      vim-polyglot
      {
        plugin = (plugin "mhinz/vim-mix-format");
      	type = "lua";
      	config = ''
      	  vim.g.mix_format_on_save = 1
          vim.g.mix_format_silent_errors = 1
      	'';
      }

      # Editing
      file-line vim-ReplaceWithRegister mkdir-nvim
      {
        plugin = comment-nvim;
      	type = "lua";
      	config = "require('Comment').setup()";
      }
      {
        plugin = leap-nvim;
      	type = "lua";
      	config = "require('leap').set_default_keymaps()";
      }

      # Testing
      asyncrun-vim
      {
        plugin = vim-test;
      	type = "lua";
      	config = ''
      	  vim.g['test#strategy'] = 'asyncrun'
          vim.cmd 'au User AsyncRunStart call asyncrun#quickfix_toggle(15, 1)'

          vim.g['test#elixir#exunit#options'] = {
            nearest = ' ',
            file = '--trace --stale',
            suite = '--stale'
          }
      	'';
      }

      # UI
      lush-nvim
      {
        plugin = gitsigns-nvim;
	      type = "lua";
	      config = "require('gitsigns').setup()";
      }
      {
        plugin = winshift-nvim;
	      type = "lua";
	      config = "require('winshift').setup()";
      }
      {
        plugin = nvim-colorizer-lua;
	      type = "lua";
	      config = "require('colorizer').setup()";
      }

      # Colorschemes
      {
        plugin = gruvbox-nvim;
	      type = "lua";
	      config = ''
	        -- vim.o.background = 'dark'

	        require("gruvbox").setup({
	          contrast = "hard"
	        })

	        vim.cmd [[
	          " colorscheme gruvbox
	          " highlight clear SignColumn
	        ]]
	      '';
      }
      {
        plugin = (plugin "pgdouyon/vim-yin-yang");
	      type = "lua";
	      config = ''
	        vim.cmd [[
	          " colorscheme yang
	        ]]
	      '';
      }
      {
        plugin = zenbones-nvim;
	      type = "lua";
	      config = ''
	        vim.o.background = 'light'

          vim.g.tokyobones_lightness = 'dim'
          vim.g.zenwritten_lightness = 'dim'
          vim.g.zenbones_lightness = 'dim'
          vim.g.seoulbones_lightness = 'dim'

	        vim.cmd [[
	          colorscheme seoulbones
	          highlight clear SignColumn
	        ]]
	      '';
      }

      # Wakatime
      {
        plugin = vim-wakatime;
        optional = true; # Does not work, crashes because it asks for API key while building
        config = "packadd vim-wakatime"; # Does work when enabling it afterwards
      }
    ];
  };
}
