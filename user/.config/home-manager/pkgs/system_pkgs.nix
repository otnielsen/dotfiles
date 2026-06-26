{
  pkgs,
}:
pkgs.buildEnv {
  name = "system-pkgs";
  paths = with pkgs; [
    (callPackage ./ly.nix { })
  ];
}
