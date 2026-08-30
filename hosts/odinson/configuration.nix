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
    ./forgejo.nix
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

  nix.package = pkgs.nixVersions.latest;

  # disks and backup
  fileSystems."/shared/scratch" = {
    device = "/dev/disk/by-uuid/8ab5db06-2328-41c7-a852-35b7d9271173";
    fsType = "ext4";
    options = ["nofail" "users"];
  };

  fileSystems."/shared/storage" = {
    device = "/dev/disk/by-uuid/44c676bf-fbdd-45bc-a0c4-6defadbfd916";
    fsType = "ext4";
    options = ["nofail" "users"];
  };

  services.restic.backups.main = {
    initialize = true;
    repository = "b2:odinson-backup:restic";
    paths = [
      "/home/nsbuitrago"
      "/home/chillwei"
      "/shared/projects"
      "/shared/storage"
      "/var/lib/forgejo"
    ];

    exclude = [
      "/home/*/target"
      "/home/*/node_modules"
      "/home/*/.venv"
      "/home/*/.cache"
      "/home/*/.cargo"
    ];

    passwordFile = "/etc/nixos/restic/secrets/password";
    environmentFile = "/etc/nixos/restic/secrets/b2.env";
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
    pruneOpts = [
      "--keep-monthly 6"
    ];
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

  # Nvidia support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";

    videoDrivers = ["nvidia"];
  };

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     tmux
     neovim
     helix
     git
     git-lfs
     btop
     wget
     gcc
     gnumake
     cudatoolkit
     linuxPackages.nvidia_x11
     cudaPackages.cudnn
     nvidia-container-toolkit
     libGLU
     libGLU
     libxi
     libxmu
     libxv
     libxrandr
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
     rclone
     restic
     codex
     eza
     jujutsu
  ];

  # tailscale
  services.tailscale.enable = true;
  services.tailscale.package = inputs.tailscale.packages.${pkgs.system}.tailscale;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # samba share
  services.samba = {
    enable = true;
    # tailscale0 is trusted above; do not expose SMB on LAN/WAN interfaces.
    openFirewall = false;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "security" = "user";
        # Only allow Tailscale + local
        "hosts allow" = "100. 192.168. 127.0.0.1";
        "hosts deny" = "0.0.0.0/0";
      };
      homes = {
        "path" = "/home/nsbuitrago";
        "valid users" = "nsbuitrago";
        "read only" = "no";
        "browseable" = "yes";
      };

      chillwei = {
        "path" = "/home/chillwei";
        "valid users" = "chillwei";
        "read only" = "no";
        "browseable" = "yes";
      };

      shared_projects = {
        "path" = "/shared/projects";
        "valid users" = "nsbuitrago chillwei";
        "read only" = "no";
        "browseable" = "yes";
      };

      shared = {
        "path" = "/shared";
        "valid users" = "nsbuitrago chillwei";
        "read only" = "no";
        "browseable" = "yes";
      };
    };
  };

  # zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # dynamic linking
  programs.nix-ld.enable = true;

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
