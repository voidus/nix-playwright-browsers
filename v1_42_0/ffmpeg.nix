{
  fetchzip,
  suffix,
  revision,
  system,
  throwSystem,
}:
fetchzip {
  url = "https://playwright.azureedge.net/builds/ffmpeg/${revision}/ffmpeg-${suffix}.zip";
  stripRoot = false;
  hash =
    {
      x86_64-linux = "sha256-47/7qePyA1OFW4WJAZaKdoa3aJSrLJi9zVsCPYjrCEw=";
      aarch64-linux = "sha256-ohI4SD0Rgw9fTfHE1tPVpxvAQHcaiUFo1+l9ujjk34M=";
    }
    .${system} or throwSystem;
}
