{lib, pkgs, ... }: {

  programs.neovim = {
    enable = true;
    extraConfig = lib.fileContents ./init.vim;
    # extraLuaConfig = lib.filecontents ./init.lua;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      vim-gitgutter
      fzf-vim
      fzf-lua
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
