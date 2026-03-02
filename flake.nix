{
  description = "My Dev Workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        git
        curl
        nano
        neovim
        rsync
        asciinema
        fastfetch
        httpie
        jq
        yq
        tmux
        tailscale
        kind
        pyrefly
        ruff
        nil
        kubectl
        alejandra
        kubernetes-helm
      ];

      shellHook = ''
        echo "❄️ Welcome to your Nix-powered Devcontainer! ❄️"
        fastfetch
      '';
    };
  };
}
