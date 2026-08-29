{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg-headless.lib
    home-manager
    htop
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
}
