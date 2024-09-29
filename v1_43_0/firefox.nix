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
        x86_64-linux = "sha256-2G6fWfoTybNR15UREgshooY10y/n30xGUpOJd57AC/s=";
        aarch64-linux = "sha256-0FTNMpmPSGpMtP/sPeCd8SOxDKRbPmKAwXcCoU9+Kp0=";
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
