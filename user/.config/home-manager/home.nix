{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    ffmpeg-headless.lib
    home-manager
    lazygit
    lf
    mesa
    mesa-demos
    mpv
    nerd-fonts.fira-code
    noto-fonts-color-emoji
    tmux
    typst
    vulkan-tools
    yt-dlp
  ];

  home.activation.myCopyToSystemAction = lib.hm.dag.entryAfter ["installPackages"] ''
    run /usr/bin/pkexec /usr/local/bin/nix-system-files.py ${config.home.username}
    run ${pkgs.stow}/bin/stow $VERBOSE_ARG --restow --no-folding --dir=${config.home.homeDirectory}/dotfiles user
  '';

  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;
}
