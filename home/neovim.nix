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
      rose-pine
      lsp-zero-nvim
      trouble-nvim
      nvim-treesitter.withAllGrammars
      playground
      harpoon
      refactoring-nvim
      undotree
      vim-fugitive
      nvim-treesitter-context
      nvim-treesitter-context
      zen-mode-nvim
      mason-nvim
      nvim-lspconfig
      mason-lspconfig-nvim
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