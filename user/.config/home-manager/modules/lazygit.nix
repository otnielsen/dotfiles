{ pkgs, lib, ... }:
let
  cyberdream = "${pkgs.vimPlugins.cyberdream-nvim}/extras/lazygit/cyberdream.yml";
  json = pkgs.runCommandLocal "cyberdream-lazygit.json" { } ''
    ${pkgs.yj}/bin/yj < ${cyberdream} > $out
  '';
  config = { gui.screenMode = "half"; notARepository = "quit"; };
in
{
  programs.lazygit = {
    enable = true;
    settings = lib.recursiveUpdate (lib.importJSON json) config;
  };
}
