# dotfiles

david's dotfiles, powered by nix

note: previous history available at [Gitlab](https://gitlab.com/dcao/dotfiles)

## installation

1. Install system configuration:

   ```shell
   $ sudo ln -sf ~/.files/configuration.nix /etc/nixos/configuration.nix
   $ sudo ln -sf ~/.files/hw-boomerang.nix /etc/nixos/hw-boomerang.nix
   $ sudo nixos-rebuild switch --upgrade
   ```

2. Install home-manager (add nixos-unstable and home-manager channels, etc.).

3. Install user configuration:

   ```shell
   $ mkdir -p ~/.config/nixpkgs
   $ ln -s ~/.files/home.nix ~/.config/nixpkgs/home.nix
   $ home-manager switch
   ```

