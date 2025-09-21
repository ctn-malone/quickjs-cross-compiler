{
  description = "QuickJS Static Compiler";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "armv7l-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        highlight = text: "\\x1b[1;38;5;212m${text}\\x1b[0m";

        qjs_version = "2025-09-13_3";
        arch =
          if system == "x86_64-linux" then "x86_64"
          else if system == "armv7l-linux" then "armv7l"
          else if system == "aarch64-linux" then "aarch64"
          else "unknown-arch";
        sha256 =
          if system == "x86_64-linux" then "sha256:0kkpmsi27bscy151g0gsax2l1hx1y5xc35pq5vgj7vvmmaj0nqd7"
          else if system == "armv7l-linux" then "sha256:1bckbkrwlhhiq96l56wrjlq11nr87gmvzp0wixk3ynslip60dv1l"
          else if system == "aarch64-linux" then "sha256:1533h4jx3b9pisaj3853fsgwkvgip7h4xljl6yhbimxi121qzswb"
          else "sha256:0000000000000000000000000000000000000000000000000000";

        quickjsStatic = pkgs.stdenv.mkDerivation {
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

      in
      {

        packages.quickjs-static = quickjsStatic;

        defaultPackage = self.packages.${system}.quickjs-static;

        apps = {
          # interpreter
          default = {
            type = "app";
            program = "${quickjsStatic}/bin/qjs.sh";
          };

          qjs = self.apps.${system}.default;

          # compiler
          qjsc = {
            type = "app";
            program = "${quickjsStatic}/bin/qjsc.sh";
          };
        };

        devShell = pkgs.mkShell {
          name = "quickjs-static";

          buildInputs = [
            pkgs.upx
            quickjsStatic
          ];

          shellHook = ''
            echo -e "To compile a JS file, use ${highlight "qjsc.sh -o <binary> <source>"}" 1>&2
            echo -e "To run a JS file, use ${highlight "qjs.sh <source>"}" 1>&2
          '';
        };
      }
    );
}
