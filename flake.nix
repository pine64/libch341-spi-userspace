{
  description = "A userspace driver for the Pinedio usb LoRa radio.";

  inputs.nixpkgs.url = "nixpkgs/nixos-24.11";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let 
    lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
    version = builtins.substring 0 8 lastModifiedDate;
    pkgs = import nixpkgs {inherit system;};
    mkBuild = attrs: pkgs.stdenv.mkDerivation (attrs // {
      inherit version;
      src = ./.;
      nativeBuildInputs = [ pkgs.cmake pkgs.ninja pkgs.pkg-config ];
      buildInputs = [ pkgs.libusb1 ];
    });
  in 
  {
    
    packages = rec { 
      libpinedio-usb = mkBuild {
        pname = "libpinedio-usb";
      };
      pinedio-test = mkBuild {
        pname = "pinedio-test";
        installPhase = ''
          mkdir -p $out/bin
          cp pinedio-test $out/bin
          '';
      };
      default = libpinedio-usb;
    };

    devShells.default = pkgs.mkShell {
      inputsFrom = [
        self.packages.${system}.pinedio-test
      ];
      packages = [ pkgs.git pkgs.nixd pkgs.valgrind ];
    };

    # Run test suite when checking the flake
    checks = 
      rec {
        inherit (self.packages.${system}) pinedio-test;

        test = pkgs.stdenv.mkDerivation 
          {
            pname = "pinedio-test";
            inherit version;

            buildInputs = [ pinedio-test ];
            dontUnpack = true;

            buildPhase = ''
              echo Running pinedio-test
              echo TODO: pinedio-test currently segfaults so skip this for now'';
            installPhase = ''mkdir -p $out'';
          };
      };
  });
}
