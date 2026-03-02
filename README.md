# VSCode Devcontainer

## Requirements
* [Docker](https://docs.docker.com/engine/install/)


This devcontainer uses `Docker outside of Docker` which assumes you have Docker installed and running on your host machine with the Docker Daemon accessible at `/var/run/docker.sock`.



* [VSCode devcontainers extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers)  ( recommended )


or


* [devcontainer](https://github.com/devcontainers/cli)  ( for CLI power users )

## VSCode Usage
1. Clone this repo
2. Open the repo in VSCode
3. Open the Command Palette (Ctrl+Shift+P)
4. Select `Reopen in Container`


## devcontainer CLI Usage
### Start the Container
```bash
devcontainer up --workspace-folder .
```

### Execute a Command in the Container
```bash
devcontainer exec --workspace-folder . nix develop
```