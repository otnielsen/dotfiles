{ config, pkgs, lib, ... }:

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

  home.activation.myCopyToSystemAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run /usr/bin/pkexec /usr/local/bin/hmcopy.sh ${config.home.username}
  '';

  home.file."." = {
    source = "${config.home.homeDirectory}/dotfiles/user";
    recursive = true;
  };

  xdg.configFile."home-manager/home.nix".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home.nix";

  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [
          "${pkgs.vimPlugins.cyberdream-nvim}/extras/alacritty/cyberdream.toml"
        ];
      };
      window = {
        decorations = "none";
        startup_mode = "Fullscreen";
      };
      keyboard.bindings = [
        {
          key = "F11";
          action = "ToggleFullscreen";
        }
      ];
      mouse = {
        hide_when_typing = true;
      };
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "cyberdream";
      vim_keys = true;
      disable_mouse = true;
      save_config_on_exit = false;
    };
    themes = {
      cyberdream = builtins.readFile "${pkgs.vimPlugins.cyberdream-nvim}/extras/btop/cyberdream.theme";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = let
        cyberdream = "${pkgs.vimPlugins.cyberdream-nvim}/extras/lazygit/cyberdream.yml";
        json = pkgs.runCommandLocal "cyberdream-lazygit.json" { } ''
          ${pkgs.yj}/bin/yj < ${cyberdream} > $out
        '';
        config = { gui.screenMode = "half"; notARepository = "quit"; };
      in
        lib.recursiveUpdate (lib.importJSON json) config;
  };

  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;
}
