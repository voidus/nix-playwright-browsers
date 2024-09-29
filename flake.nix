{
  description = "Provides nix derivations for playwright browsers in various versions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        playwright-driver = (pkgs.callPackage ./v1_47_0/driver.nix {}).playwright-core;
      in
      {
        packages = {
          v1_47_0 = playwright-driver.browsers;
        };
      }
    );
}
