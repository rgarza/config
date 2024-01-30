{ home, pkgs, ... }: {

  imports = [ ];

home.file."./.config/nvim/" = {
  source = ../configs/nvim;
  recursive = true;
};

 programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = false;
    withNodeJs = true;

    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      packer-nvim
      tokyonight-nvim
      plenary-nvim
      lsp-zero-nvim
      trouble-nvim
      nvim-treesitter.withAllGrammars
      playground
      nvim-treesitter-textobjects
      harpoon
      refactoring-nvim
      undotree
      vim-fugitive
      rust-tools-nvim
      nvim-treesitter-context
      nvim-treesitter-context
      zen-mode-nvim
      none-ls-nvim
      direnv-vim
      nvim-lspconfig
      telescope-nvim
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp_luasnip
      cmp-nvim-lsp
      cmp-nvim-lua
      luasnip
      friendly-snippets
    ];
  };
}
