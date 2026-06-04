{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ffmpeg-headless.lib
    home-manager
    mesa
    mesa-demos
    vulkan-tools
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;
}
