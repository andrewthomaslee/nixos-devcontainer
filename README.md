# NixOS as a Devcontainer
### Pull the Image
```bash
docker pull andrewthomaslee/nixos-devcontainer:latest
```

### Run the Container
```bash
docker run -d \
  --name nixos-devcontainer \
  --privileged \
  --cap-add=SYS_ADMIN \
  --security-opt=seccomp=unconfined \
  --tmpfs /run \
  --tmpfs /run/lock \
  --tmpfs /tmp \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  -v nixos-devcontainer-store-data:/nix \
  -v nixos-devcontainer-docker-data:/var/lib/docker \
  andrewthomaslee/nixos-devcontainer:latest
```

### Connect to the Container
```bash
docker exec -it nixos-devcontainer su - code
```



# Building the Image
### Build the Tarball
```bash
nix build .#nixosConfigurations.devcontainer.config.system.build.tarball
```

### Import the Tarball
```bash
docker import \
  --change 'ENTRYPOINT ["/init"]' \
  result/tarball/nixos-system-x86_64-linux.tar.xz \
  andrewthomaslee/nixos-devcontainer:latest
```