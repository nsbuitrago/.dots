
# N N         NB B B B B B
# N  N        NB         B
# N   N       NB         B
# N    N      NB         B
# N     N     NB B B B B B
# N      N    NB         B
# N       N   NB         B
# N        N  NB         B
# N         N NB B B B B B

{
  description = "NSBuitrago's NixOS Configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    nsbUser = "nsbuitrago";
    chillweiUser = "chillwei";
    odinsonHostname = "odinson";
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      odinson = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs nsbUser chillweiUser odinsonHostname;};
        # > main nixos configuration file <
        modules = [./nixos/configuration.nix];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "${nsbUser}@${odinsonHostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs nsbUser;};
        # > main home-manager configuration file <
        modules = [./home-manager/nsb-home.nix];
      };

      "${chillweiUser}@${odinsonHostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs chillweiUser;};
        # > main home-manager configuration file <
        modules = [./home-manager/chillwei-home.nix];
      };
    };
  };
}
