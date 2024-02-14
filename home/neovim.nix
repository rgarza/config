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
      nightfox-nvim
      plenary-nvim
      lsp-zero-nvim
      trouble-nvim
      nvim-treesitter.withAllGrammars
      playground
      nvim-web-devicons
      go-nvim
      refactoring-nvim
      undotree
      neorg
      vim-fugitive
      nvim-treesitter-context
      nvim-treesitter-textobjects
      comment-nvim
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
      harpoon2
      vim-terraform
      copilot-vim
      lualine-nvim
    ];
  };
}
