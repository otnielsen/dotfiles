{
  ly,
}:
(ly.override { x11Support = false; }).overrideAttrs (prev: {
  zigBuildFlags = prev.zigBuildFlags ++ [
    "installexe"
    "-Ddest_directory=${placeholder "out"}"
    "-Doptimize=ReleaseSafe"
    "-Dcpu=haswell"
  ];

  postInstall = ''
    mv "$out/usr"/* "$out"
    rmdir "$out/usr"

    substituteInPlace "$out/lib/systemd/system/ly@.service" \
        --replace-fail /usr/bin/ly "$out/bin/ly"
  '';

  postFixup = ''
    _prev_rpath=$(patchelf --print-rpath "$out/bin/ly")
    patchelf --force-rpath --set-rpath "/usr/lib64''${_prev_rpath:+:$_prev_rpath}" "$out/bin/ly"
    unset _prev_rpath
  '';

  dontUseZigInstall = true;
  dontSetZigDefaultFlags = true;
})
