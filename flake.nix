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
        pkgs = nixpkgs.legacyPackages.${system};
        highlight = text: "\\x1b[1;38;5;212m${text}\\x1b[0m";
        qjs_version = "2024-01-13_3";
        arch =
          if system == "x86_64-linux" then "x86_64"
          else if system == "armv7l-linux" then "armv7l"
          else if system == "aarch64-linux" then "aarch64"
          else "unknown-arch";
        sha256 =
          if system == "x86_64-linux" then "sha256:10lzv5h0iidyfbqghyhdvwhnha095fhfxwx133iyfb906zaz3rih"
          else if system == "armv7l-linux" then "sha256:0hyj5nnirang29f9av7dn5wq8nk8sz86vpzarqzg5kapk4yklw11"
          else if system == "aarch64-linux" then "sha256:05myyxk3hlsd7d1rkixv2kfip7dbhra9vnxcmhnz9ficvypm0m8d"
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

        apps = {
          # interpreter
          default = {
            type = "app";
            program = "${self.packages.${system}.quickjs-static}/bin/qjs.sh";
          };

          qjs = self.apps.${system}.default;

          # compiler
          qjsc = {
            type = "app";
            program = "${self.packages.${system}.quickjs-static}/bin/qjsc.sh";
          };
        };

        devShell = pkgs.mkShell {
          name = "quickjs-static";

          buildInputs = [
            pkgs.upx
            self.packages.${system}.quickjs-static
          ];

          shellHook = ''
            echo -e "To compile a JS file, use ${highlight "qjsc.sh -o <binary> <source>"}" 1>&2
            echo -e "To run a JS file, use ${highlight "qjs.sh <source>"}" 1>&2
          '';
        };
      }
    );
}
