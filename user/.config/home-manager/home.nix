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
    run ${pkgs.stow}/bin/stow $VERBOSE_ARG --restow --no-folding --dir=${config.home.homeDirectory}/dotfiles user
  '';

  xdg.configFile = {
    "htop/htoprc".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
    "nvtop/interface.ini".source = config.lib.file.mkOutOfStoreSymlink "/dev/null";
  };

  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;
}
