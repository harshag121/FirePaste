{
  description = "FirePaste - Ephemeral Pastebin with burn-after-reading";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.buildGoModule {
          pname = "firepaste";
          version = "0.1.0";

          src = ./.;

          vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Run nix build to get actual hash

          ldflags = [ "-s" "-w" ];

          meta = with pkgs.lib; {
            description = "Ephemeral pastebin with burn-after-reading capability";
            homepage = "https://github.com/harshag121/FirePaste";
            license = licenses.mit;
            maintainers = [ ];
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go_1_22
            gopls
            gotools
            go-tools
            redis
            docker
            docker-compose
            k6
            asciinema
          ];

          shellHook = ''
            echo "🔥 FirePaste Development Environment"
            echo "=================================="
            echo "Available commands:"
            echo "  go build ./cmd/server    - Build the server"
            echo "  make up                  - Start docker stack"
            echo "  make bench               - Run load tests"
            echo "  ./scripts/record_demo.sh - Record demo"
            echo ""
          '';
        };

        # Allow running with: nix run github:harshag121/FirePaste
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/firepaste";
        };
      }
    );
}
