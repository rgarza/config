{pkgs, ...}:
final: prev:
# needed because of https://github.com/NixOS/nixpkgs/issues/160133
let
  inherit (prev) python3 fetchFromGitHub;
  inherit (prev.python3.pkgs) buildPythonApplication;
in

{
  python3 = python3.override {
    packageOverrides = self: super: {

     ipython = super.ipython.overridePythonAttrs(old: rec {
        preCheck = old.preCheck + pkgs.lib.optionalString super.stdenv.isDarwin ''
          # Fake the impure dependencies pbpaste and pbcopy
          echo "#!${pkgs.stdenv.shell}" > pbcopy
          echo "#!${pkgs.stdenv.shell}" > pbpaste
          chmod a+x pbcopy pbpaste
          export PATH=$(pwd):$PATH
        '';
      });

    };
  };
}