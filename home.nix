{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    btop
    ffmpeg-headless.lib
    home-manager
    htop
    lazygit
    lf
    llama-cpp-vulkan
    mangohud
    mesa
    mesa-demos
    mpv
    nerd-fonts.fira-code
    noto-fonts-color-emoji
    nvtopPackages.amd
    tmux
    typst
    umu-launcher
    vulkan-tools
    yt-dlp
  ];

  home.activation.myCopyToSystemAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run /usr/bin/pkexec /usr/local/bin/hmcopy.sh ${config.home.username}
  '';

  home.file."." = {
    source = "${config.home.homeDirectory}/dotfiles/user";
    recursive = true;
  };

  xdg.configFile."home-manager/home.nix".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home.nix";

  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;
}
