{
  description = "NixOS Devcontainer with DinD";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: {
    nixosConfigurations.devcontainer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({pkgs, ...}: {
          # Tell NixOS it is booting inside a container
          boot.isContainer = true;

          # Enable Flakes
          nix.settings.experimental-features = ["nix-command" "flakes"];

          # Enable Docker-in-Docker
          virtualisation.docker.enable = true;

          # Install packages you want available immediately
          environment.systemPackages = with pkgs; [git nano curl docker];

          # Set up the VS Code remote user
          users.users.vscode = {
            isNormalUser = true;
            extraGroups = ["wheel" "docker"];
            password = ""; # Optional: configure passwordless sudo
          };
          security.sudo.wheelNeedsPassword = false;
        })
      ];
    };
  };
}
