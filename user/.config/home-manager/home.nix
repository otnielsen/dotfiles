{ pkgs, config, lib, ... }:

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
  home.stateVersion = "26.05";
  home.enableNixpkgsReleaseCheck = false;

  _module.args = {
    withgamemode = pkg: bin: pkgs.symlinkJoin {
      pname = "${pkg.pname}-withgamemode";
      version = pkg.version;
      paths = [
        pkg
      ];
      nativeBuildInputs = [
        pkgs.makeBinaryWrapper
      ];
      postBuild = ''
        wrapProgram "$out/bin/${bin}" \
            --prefix LD_LIBRARY_PATH : '${pkgs.gamemode.lib}/lib'
      '';
    };
    firejailed = pkg: bin: pkgs.symlinkJoin {
      pname = "${pkg.pname}-firejailed";
      version = pkg.version;
      paths = [
        pkg
      ];
      nativeBuildInputs = [
        pkgs.makeWrapper
      ];
      postBuild = ''
        wrapProgram "$out/bin/${bin}" \

        substituteInPlace "$out/bin/${bin}" \
            --replace-fail 'exec -a "$0"' '${builtins.concatStringsSep " " [
              "exec"
              "firejail"
              "--profile=default"
              ''--whitelist="${config.xdg.stateHome}/nix/profile"''
              ''--whitelist="${config.xdg.configHome}/gtk-3.0"''
            ]}'
      '';
    };
  };
}
