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
        qjs_version = "2024-01-13_1";
        arch =
          if system == "x86_64-linux" then "x86_64"
          else if system == "armv7l-linux" then "armv7l"
          else if system == "aarch64-linux" then "aarch64"
          else "unknown-arch";
        sha256 =
          if system == "x86_64-linux" then "sha256:00rk22na9vlfn3jpj2wjqhaqxz8r6j7wp5nr2pn84nwziy7xvkf5"
          else if system == "armv7l-linux" then "sha256:0wk3n8rmnpnjpgn2ab375d7halr6cxi8fh6bvvzahq27pbf79yy5"
          else if system == "aarch64-linux" then "sha256:139lfvdfbjix0z6szsq0nmmx3jvbgj56amqlg877830af2vhmr3g"
          else "sha256:0000000000000000000000000000000000000000000000000000";
      in
      {

        packages.quickjs-static = pkgs.stdenv.mkDerivation {
          name = "quickjs-static";

          src = builtins.fetchTarball {
            url = "https://github.com/ctn-malone/quickjs-cross-compiler/releases/download/v${qjs_version}/quickjs.core.${qjs_version}.${arch}.tar.xz";
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
