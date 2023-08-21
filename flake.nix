{
  description = "Flake for libDaisy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }@inputs:
    utils.lib.eachDefaultSystem
      (system:
        let
          # gcc-arm-embedded-10 doesn't support aarch64-darwin
          buildSystem = if system == "aarch64-darwin" then  "x86_64-darwin" else system;
          pkgs = import nixpkgs { system = buildSystem; };
        in
        {
          packages = with pkgs;{
            default = pkgs.stdenv.mkDerivation {
              pname = "libDaisy";
              version = "5.4.0";
              src = ./.;

              nativeBuildInputs = [
                cmake
                ninja
                gcc-arm-embedded-10
              ];

              cmakeFlags = [
                "-DCMAKE_MAKE_PROGRAM=${ninja}/bin/ninja"
                "-DTOOLCHAIN_PREFIX=${gcc-arm-embedded-10}"
                "-DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/stm32h750xx.cmake"
              ];

              meta = with lib;
                {
                  description = "Hardware Abstraction Library for the Daisy Audio Platform ";
                  license = licenses.mit;
                  platforms = platforms.all;
                };
            };
          };

        });
}


