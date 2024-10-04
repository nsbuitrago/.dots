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
    homeDirectory = "/home/nsb";
  };

  home.packages = with pkgs; [ 
    nodejs # the following 2 pkgs are soft dependencies for nvim
    fd
    stow
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git.enable = true;
  programs.git.lfs.enable = true;
  programs.gh.enable = true;

  programs.zoxide.enable = true;
  programs.lazygit.enable = true;
  programs.wezterm.enable = true;
  programs.zellij.enable = true;
  programs.fish.enable = true;
  home.file.".config/zellij/config.kdl".source = ./dots/zellij/config.kdl;

  programs.starship = { 
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    defaultEditor = true;
  };

  # soft dependencies for nvim configuration
  programs.ripgrep.enable = true;
  programs.fzf.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
