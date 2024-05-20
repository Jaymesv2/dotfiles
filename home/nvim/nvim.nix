{config, lib, pkgs, ... }: let 
  mutable_conf = true;
  utils = import ./utils.nix {inherit config pkgs lib; };
in {


  imports = [
  ] ++ (if true then 
    [({...}: { 
    })]
  else 
    [({...}: {

    })]
  );

  home.packages = with pkgs; [
    clang-tools
  ];





  programs.neovim = let
    #vimconf = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/home/nvim/init.vim";
    luaconf = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/home/nvim/init.lua";
  in {
    enable = true;

    #extraLuaConfig = "require('${luaconf}')";
    #extraLuaConfig = "require('${config.home.homeDirectory}/.config/nix/home/nvim/init')";
    #extraConfig = "source ${vimconf}";
    #extraConfig = lib.fileContents ./init.vim;

    # extraLuaConfig = lib.filecontents ./init.lua;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      vim-gitgutter
      #fzf-vim
      #fzf-lua
      plenary-nvim
      telescope-nvim

      ale
      nerdtree
      nerdtree-git-plugin
      vim-multiple-cursors
      onedark-nvim
      vim-fugitive
      neomake
      vimspector
      markdown-preview-nvim
    ];


  };
  
}
