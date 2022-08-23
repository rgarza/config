{ config, pkgs, lib, ... }:
# Let-In ----------------------------------------------------------------------------------------{{{
let
  inherit (lib) optional;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home.user-info) nixConfigDirectory;

  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });

in
{
  programs.neovim.enable = true;  
  xdg.configFile."nvim/lua".source = mkOutOfStoreSymlink "/Users/rd/.nixpkgs/configs/nvim/lua";
  programs.neovim.extraConfig = "lua require('init')";

  programs.neovim.plugins = with pkgs.vimPlugins; [
    colorbuddy-nvim
    packer-nvim
    NeoSolarized
  ];

 }
