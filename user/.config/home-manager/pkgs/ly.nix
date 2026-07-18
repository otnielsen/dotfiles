{
  ly,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "ly-custom";
  version = ly.version;

  src = ly.src;

  installPhase = ''
    install -Dm755 ${ly}/bin/ly -t "$out/bin"
    install -Dm755 res/setup.sh -t "$out/etc/ly"
    install -Dm644 res/config.ini -t "$out/etc/ly"
    install -Dm644 res/ly@.service -t "$out/lib/systemd/system"
    install -Dm644 res/pam.d/ly-linux "$out/etc/pam.d/ly"

    substituteInPlace "$out/etc/ly/config.ini" \
        --replace-fail '$CONFIG_DIRECTORY' '/etc' \
        --replace-fail '$PREFIX_DIRECTORY' '/usr'

    substituteInPlace "$out/etc/ly/setup.sh" \
        --replace-fail '$CONFIG_DIRECTORY' '/etc'

    substituteInPlace "$out/lib/systemd/system/ly@.service" \
        --replace-fail '$PREFIX_DIRECTORY/bin/$EXECUTABLE_NAME' "$out/bin/ly"
  '';

  postFixup = ''
    _prev_rpath=$(patchelf --print-rpath "$out/bin/ly")
    patchelf --force-rpath --set-rpath "/usr/lib64''${_prev_rpath:+:$_prev_rpath}" "$out/bin/ly"
    unset _prev_rpath
  '';
}
