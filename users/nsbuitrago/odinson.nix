# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  nsbUser,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home.username = "nsbuitrago";
  home = {
    homeDirectory = "/home/nsbuitrago";

    file = {
      ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/gitconfig";
      ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/zshrc";
      ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/starship.toml";
      ".config/zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/zellij/config.kdl";
      ".config/helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/helix/config.toml";
    };
  };

  home.packages = with pkgs; [ 
    python313Packages.huggingface-hub
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git.enable = true;
  programs.git.lfs.enable = true;
  programs.gh.enable = true;

  programs.zoxide.enable = true;
  programs.lazygit.enable = true;

  programs.starship = { 
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
