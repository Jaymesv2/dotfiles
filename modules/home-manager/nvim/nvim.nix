{config, lib, pkgs, pkgs-unstable, ... }: let 
in {
  imports = [ ../../../home/util/workingFiles.nix ];
  workingFiles.enable = true;
  workingFiles.file.neovimConfig.linkSource = ".config/nix/modules/home-manager/nvim";
  # 
  programs.neovim.package = pkgs-unstable.neovim-unwrapped; 
  home.file.neovimConfig = {
      enable = true;
      source = ./.;
      recursive = true;
      target = ".config/nvim";
  };

  home.packages = with pkgs; [
    neovide
    clang-tools
    nixd
    lazygit
    fzf
    fd
    ripgrep
    lua-language-server
  ];

  programs.neovim = {

    enable = true;
    extraLuaPackages = luaPkgs: with luaPkgs; [ jsregexp ];



    # Need to package some plugins
    # https://github.com/someone-stole-my-name/yaml-companion.nvim
    # https://github.com/cuducos/yaml.nvim
    # https://github.com/LeonHeidelbach/trailblazer.nvim
    # https://github.com/mcauley-penney/visual-whitespace.nvim
    # https://github.com/mfussenegger/nvim-treehopper
    # https://github.com/cbochs/portal.nvim
    # https://github.com/roobert/tabtree.nvim

    # looks cool
    # https://github.com/t-troebst/perfanno.nvim
    # https://github.com/tanvirtin/vgit.nvim # compare with gitsigns.nvim
    # https://github.com/jamestthompson3/nvim-remote-containers
    # https://github.com/nvim-focus/focus.nvim

    # https://github.com/m4xshen/hardtime.nvim
# Need to look into
    # - smart renaming
    # - 
    /*
        vim-mips = (pkgs.callPackage ({ vimUtils, fetchFromGitHub, ... }:  vimUtils.buildVimPlugin {
            pname = "vim-mips";
            version = "2022-03-20";
            src = fetchFromGitHub {
              owner = "benknoble";
              repo = "vim-mips";
              sha256 = "";
        #       sha256 = lib.fakeSha256;
            };
            meta.homepage = "https://github.com/benknoble/vim-mips";
        }) {});
*/


    plugins = let 
        /* extraPlugins = { lib, vimUtils, neovimUtils, fetchFromGitHub, ... }:  final: prev: {
            bufresize-nvim = vimUtils.buildVimPlugin {
                pname = "bufresize";
                version = "2022-03-20";
                src = fetchFromGitHub {
                  owner = "kwkarlwang";
                  repo = "bufresize.nvim";
                  rev = "3b19527ab936d6910484dcc20fb59bdb12322d8b";
                  hash = "sha256-6jqlKe8Ekm+3dvlgFCpJnI0BZzWC3KDYoOb88/itH+g=";
                };
                meta.homepage = "https://github.com/kwkarlwang/bufresize.nvim";
            };
        };
        plugins = pkgs.vimPlugins.extend (pkgs.callPackage extraPlugins {});
    in (with plugins; [ */
        bufresize-nvim = pkgs-unstable.vimUtils.buildVimPlugin {
            pname = "bufresize";
            version = "2022-03-20";
            src = pkgs.fetchFromGitHub {
              owner = "kwkarlwang";
              repo = "bufresize.nvim";
              rev = "3b19527ab936d6910484dcc20fb59bdb12322d8b";
              hash = "sha256-6jqlKe8Ekm+3dvlgFCpJnI0BZzWC3KDYoOb88/itH+g=";
            };
            meta.homepage = "https://github.com/kwkarlwang/bufresize.nvim";
        };
        # hbac-nvim = pkgs-unstable.vimUtils.buildVimPlugin {
        #     pname = "hbac-nvim";
        #     version = "2022-05-28";
        #     src = pkgs.fetchFromGitHub {
        #       owner = "axkirillov";
        #       repo = "hbac.nvim";
        #       rev = "991b13a33a017f4e5d73a483d2aab53bd5490c17";
        #       hash = "sha256-JDMP7Nmh5S7eDLd2sJMYrEDZ9W1J/iAtJ8Zuo0rfzEE=";
        #     };
        #     meta.homepage = "https://github.com/axkirillov/hbac.nvim";
        # };
        makeOptional = x: {plugin = x; optional = true;};
    in [ # non lazy plugins
        pkgs-unstable.vimPlugins.lz-n
    ] ++ /*builtins.map makeOptional*/ (with pkgs-unstable.vimPlugins; [

      bufresize-nvim
      # hbac-nvim

      # Treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      nvim-treesitter-context # https://github.com/nvim-treesitter/nvim-treesitter-context

      # Motions
      leap-nvim # https://github.com/ggandor/leap.nvim
      harpoon2 # https://github.com/ThePrimeagen/harpoon/tree/harpoon2
      # 
      nvim-spider # https://github.com/chrisgrieser/nvim-spider
      # tabout-nvim # https://github.com/abecodes/tabout.nvim

      actions-preview-nvim

      # test framework
      # neotest # https://github.com/nvim-neotest/neotest


      # UI
      # dashboard-nvim
      nvim-tree-lua # https://github.com/nvim-tree/nvim-tree.lua
      dressing-nvim # https://github.com/stevearc/dressing.nvim?tab=readme-ov-file
      nvim-notify # https://github.com/rcarriga/nvim-notify
      nui-nvim # https://github.com/MunifTanjim/nui.nvim

      # dont need scope :/
      #  scope-nvim # https://github.com/tiagovla/scope.nvim

      smart-splits-nvim # https://github.com/mrjones2014/smart-splits.nvim

      # dropbar-nvim # https://github.com/Bekaboo/dropbar.nvim?tab=readme-ov-file#similar-projects

      statuscol-nvim # https://github.com/luukvbaal/statuscol.nvim



        # Telescope
        telescope-nvim
        telescope-fzf-native-nvim # https://github.com/nvim-telescope/telescope-fzf-native.nvim


      # winshift-nvim # https://github.com/sindrets/winshift.nvim
      # nvim-window-picker # https://github.com/s1n7ax/nvim-window-picker/

      
      which-key-nvim # https://github.com/folke/which-key.nvim
      mini-icons
      legendary-nvim # 

      #vim-illuminate # https://github.com/RRethy/vim-illuminate


        # Status line
        lualine-nvim # https://github.com/nvim-lualine/lualine.nvim
        heirline-nvim # https://github.com/rebelot/heirline.nvim

        # Buffer line
        # nvim-cokeline # https://github.com/willothy/nvim-cokeline
        # barbar-nvim # https://github.com/romgrk/barbar.nvim?tab=readme-ov-file#integrations
        bufferline-nvim # https://github.com/akinsho/bufferline.nvim

        # Scroll
        # neoscroll-nvim # https://github.com/karb94/neoscroll.nvim

        # Scrollbar
        nvim-scrollview # https://github.com/dstein64/nvim-scrollview
        # maybe https://github.com/wfxr/minimap.vim


      # Task Management stuff
      overseer-nvim # https://github.com/stevearc/overseer.nvim/tree/master
      # neomake
      toggleterm-nvim # https://github.com/akinsho/toggleterm.nvim
      # nix-develop-nvim # https://github.com/figsoda/nix-develop.nvim

      iron-nvim # https://github.com/Vigemus/iron.nvim
      neorepl-nvim # https://github.com/ii14/neorepl.nvim

    
      # Workspace management
      # direnv-vim
      # editorconfig-vim # https://github.com/editorconfig/editorconfig-vim

      # never works :/
      # auto-session # https://github.com/rmagatti/auto-session


      # Editing

        # Comments
        comment-nvim # https://github.com/numToStr/Comment.nvim
        # todo-comments-nvim # https://github.com/folke/todo-comments.nvim
        # Nice things

        # Peeklines
        # numb-nvim # https://github.com/nacro90/numb.nvim
        
        renamer-nvim # https://github.com/filipdutescu/renamer.nvim
        nvim-autopairs # https://github.com/windwp/nvim-autopairs

        nvim-surround # https://github.com/kylechui/nvim-surround
        nvim-ufo # https://github.com/kevinhwang91/nvim-ufo
        indent-blankline-nvim # https://github.com/lukas-reineke/indent-blankline.nvim?tab=readme-ov-file
        # vim-multiple-cursors

      # Quickfix
      # nvim-bqf # https://github.com/kevinhwang91/nvim-bqf


      # Code Completion
        # coq completions
        # coq_nvim # https://github.com/ms-jpq/coq_nvim

        # nvim-cmp stuff
        cmp-nvim-lsp # https://github.com/hrsh7th/cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        nvim-cmp
        cmp_luasnip
        cmp-nvim-lsp-document-symbol
        cmp-nvim-lsp-signature-help

      # Snippets
      luasnip # https://github.com/L3MON4D3/LuaSnip
      friendly-snippets # https://github.com/rafamadriz/friendly-snippets

      # LSP config
      nvim-lspconfig
      nvim-lsputils
      lspsaga-nvim
      lsp_lines-nvim # https://git.sr.ht/~whynothugo/lsp_lines.nvim
      
      # DAP
      # nvim-dap # https://github.com/mfussenegger/nvim-dap
      # nvim-dap-ui # https://github.com/rcarriga/nvim-dap-ui
      # nvim-dap-virtual-text # https://github.com/theHamsta/nvim-dap-virtual-text
      # telescope-dap-nvim # https://github.com/nvim-telescope/telescope-dap.nvim/

      # Git integration
      vim-fugitive
      gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim
      # diffview-nvim # https://github.com/sindrets/diffview.nvim
      # git-conflict-nvim # https://github.com/akinsho/git-conflict.nvim




      # Language Support
        lean-nvim
        Coqtail # https://github.com/whonore/Coqtail
        rustaceanvim # https://github.com/mrcjkb/rustaceanvim
        vimtex # 

        # Haskell
        haskell-tools-nvim # https://github.com/mrcjkb/haskell-tools.nvim
        haskell-snippets-nvim
        telescope_hoogle
        # neotest-haskell # https://github.com/MrcJkb/neotest-haskell
        # haskell-debug-adapter # https://github.com/phoityne/haskell-debug-adapter/



      # markdown-preview-nvim # https://github.com/iamcco/markdown-preview.nvim
      conform-nvim # https://github.com/stevearc/conform.nvim


      nvim-sops # https://github.com/lucidph3nx/nvim-sops

      # Deps
      plenary-nvim

      # Theme 
      tokyonight-nvim # https://github.com/folke/tokyonight.nvim
      # gruvbox-baby # https://github.com/luisiacc/gruvbox-baby
      # onedark-nvim # https://github.com/navarasu/onedark.nvim
      # nightfox-nvim # https://github.com/EdenEast/nightfox.nvim

      # Icons
      nvim-web-devicons
    ]);


  };
  
}
