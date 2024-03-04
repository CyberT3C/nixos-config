# nixos-config
## execute
```bash
export NIX_PATH="nixos-config=/home/developer/Dokumente/software/github/nixos-config/configuration.nix:"$NIX_PATH
sudo nixos-rebuild switch  
```
# for some reason my export just works after moving files in /etc/nixos
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak
## todo
- [ ] make a nice path setup // disliking uppercase german names like ~/Dokumente/
