{
  lib,
  stdenv,
  fetchzip,
  firefox-bin,
  suffix,
  revision,
  system,
  throwSystem,
}:
let
  suffix' =
    if lib.hasPrefix "linux" suffix then "ubuntu-22.04" + (lib.removePrefix "linux" suffix) else suffix;
in
stdenv.mkDerivation {
  name = "playwright-firefox";
  src = fetchzip {
    url = "https://playwright.azureedge.net/builds/firefox/${revision}/firefox-${suffix'}.zip";
    hash =
      {
        x86_64-linux = "sha256-O4ky97/sOofY5jEKK32P9fWc97jI6804yFDQtfrdZks=";
        aarch64-linux = "sha256-h0MeeYwIVJeTZZ5SMnyFCB7A9N2rkewasDJnvQzq/Hk=";
      }
      .${system} or throwSystem;
  };

  inherit (firefox-bin.unwrapped)
    nativeBuildInputs
    buildInputs
    runtimeDependencies
    appendRunpaths
    patchelfFlags
    ;

  buildPhase = ''
    mkdir -p $out/firefox
    cp -R . $out/firefox
  '';
}
