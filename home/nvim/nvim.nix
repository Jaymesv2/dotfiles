{config, lib, pkgs, ... }: let 
  mutable_conf = true;
  utils = import ./utils.nix {inherit config pkgs lib; };
    vimconf = config.lib.file.mkOutOfStoreSymlink "~/.config/nix/home/nvim/init.vim";
    luaconf = config.lib.file.mkOutOfStoreSymlink "~/.config/nix/home/nvim/init.lua";

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
  ];

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars

      #project-nvim
      # neovim-project

      lualine-nvim

      dashboard-nvim

      comment-nvim

      vim-surround

      editorconfig-vim

      # Code Completion
      nvim-cmp
      indent-blankline-nvim

      # Git integration
      vim-fugitive
      gitsigns-nvim

      # Snippets
      luasnip
      friendly-snippets
      vim-gitgutter
    
      # LSP config
      nvim-lspconfig
      nvim-lsputils
      nvim-tree-lua
      
      # DAP
      nvim-dap

      # 
      nvim-ufo # folds

      haskell-tools-nvim

      nvim-cokeline

      vim-floaterm

      #fzf-vim
      #fzf-lua
      plenary-nvim
      telescope-nvim

      overseer-nvim

      ale
      #nerdtree
      #nerdtree-git-plugin
      vim-multiple-cursors
      onedark-nvim
      neomake
      vimspector
      markdown-preview-nvim

      nvim-web-devicons

      conform-nvim

      direnv-vim
    ];


  };
  
}
