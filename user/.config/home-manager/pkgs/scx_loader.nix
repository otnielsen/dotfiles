{
  makeBinaryWrapper,
  scx,
  scx-loader,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "scx-loader-custom";
  version = scx-loader.version;

  src = scx-loader.src;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    install -Dm755 ${scx-loader}/bin/scx_loader \
                   ${scx-loader}/bin/scxctl \
                   -t "$out/bin"

    wrapProgram "$out/bin/scx_loader" \
        --prefix PATH : ${scx.rustscheds}/bin

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

    substituteInPlace "$out/lib/systemd/system/scx_loader.service" \
                      "$out/share/dbus-1/system-services/org.scx.Loader.service" \
                      --replace-fail "/usr/bin/scx_loader" "$out/bin/scx_loader"
  '';
}
