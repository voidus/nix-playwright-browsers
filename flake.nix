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
    let
      versions = [
        "v1_47_0"
        "v1_46_0"
        "v1_45_1"
        "v1_45_0"
        "v1_44_0"
        "v1_43_0"
        "v1_42_0"
        # Versions older than 1.41.0 don't seem to build. PRs welcome if you need them, but I think
        # most people are more interested in the recent ones.
        # "v1_41_2"
        # "v1_41_1"
        # "v1_41_0"
        # "v1_40_0"
        # "v1_39_0"
        # "v1_38_0"
        # "v1_37_0"
        # "v1_36_0"
        # "v1_35_0"
        # "v1_34_0"
        # "v1_33_0"
        # "v1_32_1"
        # "v1_32_0"
        # "v1_31_1"
        # "v1_31_0"
        # "v1_30_0"
        # "v1_29_1"
        # "v1_29_0"
        # "v1_28_0"
        # "v1_27_1"
        # "v1_27_0"
        # "v1_26_1"
        # "v1_26_0"
      ];
      inherit (builtins) listToAttrs;
      inherit (nixpkgs.lib) genAttrs;
    in
    flake-utils.lib.eachDefaultSystem (system: {
      overlays = {
        default = (
          final: prev:
          listToAttrs (
            map (version: {
              name = "playwright-browsers_${version}";
              value = final.callPackage self.recipes.${version} { };
            }) versions
          )
        );
      };
      packages =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.${system}.default ];
          };
        in
        genAttrs (map (v: "playwright-browsers_${v}") versions) (version: pkgs.${version});
    })
    // {
      recipes = genAttrs versions (
        version:
        # Wrapping callPackages stuff turned out to be a bit more tricky than I expected, but
        # I think this is working. If this causes issues, we can always just edit the generated
        # files.
        args@{ callPackage, ... }:
        (callPackage ./${version}/driver.nix args).playwright-core.browsers
      );
    };
}
