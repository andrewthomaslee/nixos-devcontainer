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
        # adds the `config.system.build.tarball` attribute
        "${nixpkgs}/nixos/modules/virtualisation/docker-image.nix"

        ({
          pkgs,
          lib,
          ...
        }: {
          boot.isContainer = true;

          environment.etc."resolv.conf".enable = false;
          environment.etc.hosts.enable = false;
          environment.etc.hostname.enable = false;
          networking.resolvconf.enable = false;
          boot.postBootCommands = lib.mkForce ''
            mkdir -p /run/systemd
            echo "docker" > /run/systemd/container
          '';
          nix.channel.enable = false;

          # Enable Docker-in-Docker
          virtualisation.docker.enable = true;

          environment.systemPackages = with pkgs; [
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
            docker
            kind
            # vscode
            pyrefly
            ruff
            nil
            kubectl
            alejandra
            kubernetes-helm
          ];

          users.users = {
            root.password = "";
            code = {
              isNormalUser = true;
              extraGroups = ["wheel" "docker"];
              password = "";
            };
          };
          security.sudo.wheelNeedsPassword = false;

          system.stateVersion = "26.05";
          nix.settings = {
            allowed-users = ["root" "code"];
            trusted-users = ["@wheel"];
            auto-allocate-uids = true;
            system-features = ["uid-range"];
            auto-optimise-store = true;
            download-buffer-size = 524288000; # 500MB
            experimental-features = [
              "nix-command"
              "flakes"
              "auto-allocate-uids"
              "cgroups"
            ];
            substituters = [
              "https://cache.nixos.org"
              "https://nix-community.cachix.org"
              "https://cache.lounge.rocks/nix-cache"
            ];
            trusted-substituters = [
              "https://cache.nixos.org"
              "https://cache.lounge.rocks"
              "https://cache.flox.dev"
              "https://devenv.cachix.org"
              "https://cache.clan.lol"
              "https://nix-community.cachix.org"
            ];
            trusted-public-keys = [
              "nix-cache:4FILs79Adxn/798F8qk2PC1U8HaTlaPqptwNJrXNA1g="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
              "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
              "cache.clan.lol-1:3KztgSAB5R1M+Dz7vzkBGzXdodizbgLXGXKXlcQLA28="
            ];
          };
        })
      ];
    };
  };
}
