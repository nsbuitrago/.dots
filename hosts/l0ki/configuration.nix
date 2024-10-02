{ pkgs, ... }:
{
  homebrew = {
    enable = true;
    brews = [
      tailscale
      podman
    ];

    casks = [
      firefox
      raycast
      obsidian
      inkscape
      "nikitabobko/tap/aerospace"
      utm
      blender
      screen-studio
      microsoft-word
      utm
      font-jetbrains-mono
    ];

    taps = [
      "cask-fonts"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix = {
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  # enable sudo auth with touch ID
  # macOS resets this file when doing system updates
  # after an update, you will need to reapply the nix-darwin configuration
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults.NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
  system.defaults.NSGlobalDomain.AppleTemperatureUnit = "Celsius";
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.dock.autohide = true;
  system.defaults.dock.mineffect = "scale";
  system.defaults.dock.orientation = "right";
  system.defaults.dock.static-only = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.finder.ShowStatusBar = true;
  system.defaults.loginwindow.GuestEnabled = false;
  system.defaults.menuExtraClock.Show24Hour = true;
  system.defaults.trackpad.Clicking = true;
  system.defaults.universalaccess.reduceMotion = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  system.stateVersion = 5;
}
