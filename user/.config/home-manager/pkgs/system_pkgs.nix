{
  pkgs,
}:
pkgs.buildEnv {
  name = "system-pkgs";
  paths = with pkgs; [
    gamemode

    (callPackage ./ly.nix { })
    (callPackage ./scx_loader.nix { })
  ];
}
