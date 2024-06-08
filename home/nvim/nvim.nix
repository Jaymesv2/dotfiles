{config, lib, pkgs, ... }: let 
  mutable_conf = true;
  #utils = import ./utils.nix {inherit config pkgs lib; };
  #  vimconf = config.lib.file.mkOutOfStoreSymlink "~/.config/nix/home/nvim/init.vim";
  #  luaconf = config.lib.file.mkOutOfStoreSymlink "~/.config/nix/home/nvim/init.lua";

    # Recursively finds all file names in the specified directory and returns a list of them all seperated by a '/' with not prefix
    # relativeNamesRec :: String -> [String]
    relativeNamesRec = dir:
        lib.lists.flatten
            (lib.attrsets.mapAttrsToList
                (name: v:
                    if v == "directory" 
                        then builtins.map (path: "${name}/${path}") (relativeNamesRec ("${dir}/${name}" ))
                        else [ name ] )
                (builtins.readDir dir));
	
    # makeFiles :: (Strias a set mapping directory entries to the corresponding file type. For instance, if directory A contains a regular file B and another directory C, then builtins.readDir ./A will return the setng -> ??) -> Path -> String -> String -> Attrset
    mirrorFiles_ = f: src: absolutPathToSrc: dst: 
        builtins.listToAttrs 
                (builtins.map 
                    (path: {name = "${dst}/${path}"; value = { source = f "${absolutPathToSrc}/${path}"; }; } )
                    (relativeNamesRec src));

    mirrorFilesOutOfStore = mirrorFiles_ config.lib.file.mkOutOfStoreSymlink;
    mirrorFiles = mirrorFiles_ (x: x);

        
in {

  imports = [
  ] ++ (if mutable_conf then 
    [({...}: { 
      home.file =
      mirrorFilesOutOfStore ./. "${config.home.homeDirectory}/.config/nix/home/nvim" ".config/nvim";

      #programs.neovim.extraConfig = "source ${vimconf}";
      # home.activation.neovimConf = lib.hm.dag.entryAfter ["writeBoundary"] ''
      #     echo "-------------------------------------------------------------"
      #     echo "------------ START MANUAL IDEMPOTENT SECTION ----------------"
      #     echo "-------------------------------------------------------------"
      #     # homedir=${config.home.homeDirectory}
      #     homedir="/home/trent"
      #     echo "****** homedir=$homedir"

      #     echo
      #     echo "------ symlinks ----"

      #     symlink() {
      #       local src="$1"
      #       local dest="$2"
      #       [[ -e "$src" ]] && {
      #           [[ -e $dest ]] && {
      #               echo "****** OK: $dest exists"
      #           } || {
      #               ln -s "$src" "$dest" || {
      #                   echo "****** ERROR: could not symlink $src to $dest"
      #               }
      #               echo "****** CHANGED: $dest updated"
      #           }
      #       } || {
      #           echo "****** ERROR: source $src does not exist"
      #       }
      #     }
      #     
      #     symlink "$homedir/.config/nix/home/nvim" "$homedir/.config/nvim" 

      #     echo "-------------------------------------------------------------"
      #     echo "------------ END MANUAL IDEMPOTENT SECTION ----------------"
      #     echo "-------------------------------------------------------------"
      # '';
    })]
  else 
    [({...}: {
      programs.neovim.extraConfig = lib.fileContents ./init.vim;
    })]
  );

  home.packages = with pkgs; [
    clang-tools
    nixd
    lazygit
    fzf
    fd
    ripgrep
  ];

  programs.neovim = {
    enable = true;



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
    plugins = with pkgs.vimPlugins; [
      # Treesitter
      nvim-treesitter.withAllGrammars
      # nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      # nvim-treesitter-context # https://github.com/nvim-treesitter/nvim-treesitter-context

      # Motions
      leap-nvim # https://github.com/ggandor/leap.nvim
      # harpoon2 # https://github.com/ThePrimeagen/harpoon/tree/harpoon2
      # 
      # nvim-spider # https://github.com/chrisgrieser/nvim-spider
      # tabout-nvim # https://github.com/abecodes/tabout.nvim


      # test framework
      # neotest # https://github.com/nvim-neotest/neotest


      # UI
      dashboard-nvim
      nvim-tree-lua # https://github.com/nvim-tree/nvim-tree.lua
      dressing-nvim # https://github.com/stevearc/dressing.nvim?tab=readme-ov-file
      nvim-notify # https://github.com/rcarriga/nvim-notify
      nui-nvim # https://github.com/MunifTanjim/nui.nvim

        # Telescope
        telescope-nvim
        telescope-fzf-native-nvim # https://github.com/nvim-telescope/telescope-fzf-native.nvim


      # smart-splits-nvim # https://github.com/mrjones2014/smart-splits.nvim
      # winshift-nvim # https://github.com/sindrets/winshift.nvim
      # nvim-window-picker # https://github.com/s1n7ax/nvim-window-picker/

      # which-key-nvim # https://github.com/folke/which-key.nvim

      # cheatsheet-nvim # https://github.com/sudormrfbin/cheatsheet.nvim/
      # vim-illuminate # https://github.com/RRethy/vim-illuminate


        # Status line
        lualine-nvim # https://github.com/nvim-lualine/lualine.nvim

        # Buffer line
        nvim-cokeline # https://github.com/willothy/nvim-cokeline

        # Scroll
        # neoscroll-nvim # https://github.com/karb94/neoscroll.nvim

        # Scrollbar
        nvim-scrollview # https://github.com/dstein64/nvim-scrollview
        # maybe https://github.com/wfxr/minimap.vim


      # Task Management stuff
      overseer-nvim # https://github.com/stevearc/overseer.nvim/tree/master
      # neomake
      # toggleterm-nvim # https://github.com/akinsho/toggleterm.nvim
      # nix-develop-nvim # https://github.com/figsoda/nix-develop.nvim

      # iron-nvim https://github.com/Vigemus/iron.nvim


      # Workspace management
      # direnv-vim
      # editorconfig-vim # https://github.com/editorconfig/editorconfig-vim
      auto-session # https://github.com/rmagatti/auto-session


      # Editing

        # Comments
        comment-nvim # https://github.com/numToStr/Comment.nvim
        # todo-comments-nvim # https://github.com/folke/todo-comments.nvim
        # Nice things

        # Peeklines
        # numb-nvim # https://github.com/nacro90/numb.nvim
        
        renamer-nvim # https://github.com/filipdutescu/renamer.nvim
        nvim-autopairs # https://github.com/windwp/nvim-autopairs

        # nvim-surround # https://github.com/kylechui/nvim-surround
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

      # Snippets
      luasnip # https://github.com/L3MON4D3/LuaSnip
      friendly-snippets # https://github.com/rafamadriz/friendly-snippets

      # LSP config
      nvim-lspconfig
      nvim-lsputils
      
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
        # Misc
        vimtex
        #  rustaceanvim # https://github.com/mrcjkb/rustaceanvim

        # Haskell
        haskell-tools-nvim # https://github.com/mrcjkb/haskell-tools.nvim
        # neotest-haskell # https://github.com/MrcJkb/neotest-haskell
        # haskell-debug-adapter # https://github.com/phoityne/haskell-debug-adapter/


      # Coqtail # https://github.com/whonore/Coqtail

      # markdown-preview-nvim # https://github.com/iamcco/markdown-preview.nvim
      conform-nvim # https://github.com/stevearc/conform.nvim


      # Deps
      plenary-nvim

      # Theme 
      tokyonight-nvim # https://github.com/folke/tokyonight.nvim
      # gruvbox-baby # https://github.com/luisiacc/gruvbox-baby
      # onedark-nvim # https://github.com/navarasu/onedark.nvim
      # nightfox-nvim # https://github.com/EdenEast/nightfox.nvim

      # Icons
      nvim-web-devicons
    ];


  };
  
}
