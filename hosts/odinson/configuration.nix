# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  nsbUser,
  chillweiUser,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      cudaSupport = true;
      cudaVersion = "12";
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  fileSystems."/shared/data2" = {
    device = "/dev/disk/by-uuid/8ab5db06-2328-41c7-a852-35b7d9271173";
    fsType = "ext4";
    options = ["nofail" "users"];
  };

  # Set your hostname
  networking.hostName = "odinson";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    docker.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };
  
  # Nvidia support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # nsb
  users.users."${nsbUser}" = {
    isNormalUser = true;
    description = "nsb";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # chillwei
  users.users."${chillweiUser}" = {
    isNormalUser = true;
    description = "chillwei";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # josefina
  users.users."jb253" = {
    isNormalUser = true;
    description = "jb253";
    extraGroups = [ "networkmanager" "docker" ];
  };

  # szablowski lab
  users.users."szablowskilab" = {
    isNormalUser = true;
    description = "SzablowskiLab";
    extraGroups = [ "networkmanager" "docker" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     tmux
     neovim
     git
     git-lfs
     btop
     wget
     tailscale
     gcc
     gnumake
     cudatoolkit
     linuxPackages.nvidia_x11
     cudaPackages.cudnn
     nvidia-container-toolkit
     libGLU
     libGLU
     xorg.libXi
     xorg.libXmu
     xorg.libXv
     xorg.libXrandr
     zlib
     ncurses5
     stdenv.cc
     binutils
     unzip
     zip
     dive
     podman-tui
     podman-compose
     docker-compose
  ];

  # tailscale
  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ 22 ];
  };

  # zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";

  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
