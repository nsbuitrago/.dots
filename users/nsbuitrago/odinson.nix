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
    inputs.noctalia.homeModules.default
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
      ".config/ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/ghostty/config";
      ".config/noctalia/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/noctalia/config.toml";
      ".config/noctalia/bar.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/noctalia/bar.toml";
      ".config/noctalia/palettes/Omarchy Mac Style.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/noctalia/palettes/Omarchy Mac Style.json";
      ".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/users/nsbuitrago/dots/niri/config.kdl";
    };
  };

  home.packages = with pkgs; [ 
    bibata-cursors
    python313Packages.huggingface-hub
    zed-editor
    devenv
  ];

  programs.noctalia.enable = true;

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    iconTheme = {
      package = pkgs.whitesur-icon-theme;
      name = "WhiteSur";
    };
  };

  fonts.fontconfig.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "application/pdf" = [ "brave-browser.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/webp" = [ "org.gnome.Loupe.desktop" ];
      "image/gif" = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
      "text/html" = [ "brave-browser.desktop" ];
      "x-scheme-handler/http" = [ "brave-browser.desktop" ];
      "x-scheme-handler/https" = [ "brave-browser.desktop" ];
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git.enable = true;
  programs.git.lfs.enable = true;
  # programs.gh.enable = true;

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
