{ config, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/user";
  recursiveSymlink = (dir:
    lib.concatMapAttrs
      (name: value:
        let
          entry = "${dir}/${name}";
        in
        if value == "directory"
        then recursiveSymlink entry
        else { ${lib.removePrefix dotfiles entry} = {
          source = config.lib.file.mkOutOfStoreSymlink entry;
        }; }
      )
      (builtins.readDir (/. + dir))
  );
in
{
  imports = [
    ./modules
  ];

  home.file = recursiveSymlink dotfiles;

  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;
}
