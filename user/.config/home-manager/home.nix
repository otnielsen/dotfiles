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

    ((ly.override { x11Support = false; }).overrideAttrs (prev: {
      zigBuildFlags = [
        "installexe"
        "-Dprefix_directory="
        "-Doptimize=ReleaseSafe"
        "-Dcpu=haswell"
      ]
      ++ prev.zigBuildFlags;

      preBuild = ''
        appendToVar zigBuildFlags "-Ddest_directory=$out"
      '';

      postInstall = ''
        substituteInPlace "$out/lib/systemd/system/ly@.service" \
            --replace-fail /bin/ly "$out/bin/ly"
      '';

      postFixup = ''
        _prev_rpath=$(patchelf --print-rpath "$out/bin/ly")
        patchelf --force-rpath --set-rpath "/usr/lib64''${_prev_rpath:+:$_prev_rpath}" "$out/bin/ly"
        unset _prev_rpath
      '';

      dontSetZigDefaultFlags = true;
    }))
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
