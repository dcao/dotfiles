{ pkgs, fetchgit }:

let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {
  "notational-fzf-vim" = buildVimPlugin {
    name = "notational-fzf-vim";
    src = ./notational-fzf;
    dependencies = [];
  };
}
