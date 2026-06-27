{
  clang,
  makeBinaryWrapper,
  mold,
  scx,
  scx-loader,
}:
scx-loader.overrideAttrs (prev: {
  cargoBuildType = "release";

  nativeBuildInputs = prev.nativeBuildInputs ++ [
    clang
    makeBinaryWrapper
    mold
  ];

  postInstall = ''
    rm "$out/bin/xtask"

    install -Dm644 services/scx_loader.service \
        -t "$out/lib/systemd/system"
    install -Dm644 services/org.scx.Loader.service \
        -t "$out/share/dbus-1/system-services"
    install -Dm644 configs/org.scx.Loader.conf \
        -t "$out/share/dbus-1/system.d"
    install -Dm644 configs/org.scx.Loader.xml \
        -t "$out/share/dbus-1/interfaces"
    install -Dm644 configs/org.scx.Loader.policy \
        -t "$out/share/polkit-1/actions"
    install -Dm644 configs/scx_loader.toml \
        "$out/share/scx_loader/config.toml"

    wrapProgram "$out/bin/scx_loader" \
        --prefix PATH : ${scx.rustscheds}/bin
  '';

  env = prev.env // {
    RUSTFLAGS = builtins.concatStringsSep " " [
      "-Clink-arg=-fuse-ld=mold"
      "-Clinker=clang"
      "-Clto=thin"
      "-Copt-level=3"
      "-Cstrip=symbols"
      "-Ctarget-cpu=haswell"
    ];
  };
})
