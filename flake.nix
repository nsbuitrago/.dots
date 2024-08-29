
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
  description = "NSBuitrago's NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
  in {

    nixosConfigurations = {
      odinson = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs nsbUser chillweiUser;};
        modules = [./hosts/odinson/configuration.nix];
      };
    };

    homeConfigurations = {
      "${nsbUser}@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs nsbUser;};
        # > main home-manager configuration file <
        modules = [./users/nsbuitrago/home.nix];
      };

      "${chillweiUser}@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs chillweiUser;};
        modules = [./users/chillwei/home.nix];
      };

      "jb253@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs chillweiUser;};
        modules = [./users/jb253/home.nix];
      };
    };
  };
}
