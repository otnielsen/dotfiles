{ config, lib, ... }:
{
  imports = [
    ./modules
  ];

  home.activation.myCopyToSystemAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run /usr/bin/pkexec /usr/local/bin/hmcopy.sh ${config.home.username}
  '';

  home.file."./." = {
    source = "${config.home.homeDirectory}/dotfiles/user";
    recursive = true;
  };

  xdg.configFile."home-manager".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager";

  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;
}
