{
  description = "Docker outside of Docker + Nix package manager + Tailscale";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {self, ...} @ inputs:
    with inputs; let
      # Nixpkgs instantiated for supported system types.
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
    in {
      devShells = forAllSystems (
        system:
          with nixpkgsFor.${system}; {
            default = pkgs.mkShell {
              packages = [
                git
                rsync
                asciinema
                fastfetch
                httpie
                jq
                yq
              ];
              shellHook = ''
                export REPO_ROOT=$(git rev-parse --show-toplevel)
                echo "❄️ Welcome to your Nix-powered Devcontainer! ❄️"
                fastfetch
              '';
            };
          }
      );

      templates.nix-devcontainer = {
        path = ./.;
        description = "Docker outside of Docker + Nix package manager + Tailscale";
      };
    };
}
