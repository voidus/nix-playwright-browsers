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
        x86_64-linux = "sha256-cTsss94JNddoCuWCKt3PMQFuwFXkl+o4SxJNaEmgNsc=";
        aarch64-linux = "sha256-p74bwMkFOtGf2SbQ8ypP/lpsSNnrUgeDvQhfMpPwZg0=";
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
