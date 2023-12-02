{
  description = "QuickJs Static Compiler";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?rev=057f9aecfb71c4437d2b27d3323df7f93c010b7e";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "armv7l-linux" "aarch64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        arch =
          if system == "x86_64-linux" then "x86_64"
          else if system == "armv7l-linux" then "armv7l"
          else if system == "aarch64-linux" then "aarch64"
          else "unknown-arch";
        sha256 =
          if system == "x86_64-linux" then "sha256:125a4q49gqyma10d12syxa90blcdyx5rfky69xmcpkwn6q8842yr"
          else if system == "armv7l-linux" then "sha256:125a4q49gqyma10d12syxa90blcdyx5rfky69xmcpkwn6q8842yr"
          else if system == "aarch64-linux" then "sha256:1rghzvqi6rjf402zg2bf94x1rnw6qc673cmdnpdcsk6ma2skqsi9"
          else "sha256:0000000000000000000000000000000000000000000000000000";
      in
      {

        packages.quickjs-static = pkgs.stdenv.mkDerivation {
          name = "quickjs-static";

          src = builtins.fetchTarball {
            url = "https://github.com/ctn-malone/quickjs-cross-compiler/releases/download/2021-03-27_4/quickjs.core.2021-03-27_4.${arch}.tar.xz";
            sha256 = sha256;
          };

          configurePhase = false;
          buildPhase = false;

          installPhase = ''
            mkdir -p $out/bin
            cp -R $src/* $out/bin
          '';
        };

        defaultPackage = self.packages.${system}.quickjs-static;

        devShell = pkgs.mkShell {
          name = "quickjs-static";

          buildInputs = [
            pkgs.upx
            self.packages.${system}.quickjs-static
          ];

          shellHook = ''
            echo "To compile a JS file, use qjsc.sh -o <binary> <source>" 1>&2
            echo "To run a JS file, use qjs.sh <source>" 1>&2
          '';
        };
      }
    );
}
