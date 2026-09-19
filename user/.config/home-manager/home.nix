{ config, lib, ... }:

let
  HOME = builtins.getEnv "HOME";
  untracked = "${HOME}/.config/home-manager/untracked.nix";
  dotfiles = "${HOME}/dotfiles/user";
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
      (builtins.readDir dir)
  );
in
{
  imports = [
    ./modules
  ] ++ (
    if builtins.pathExists untracked
    then [ untracked ]
    else [ ]
  );

  home.file = recursiveSymlink dotfiles;

  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = HOME;
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;
}
