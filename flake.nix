#N NN         NN   SSSSSSSSSSS  BBBBBBBBBBBB
#N  NN        NN  SS            BB         BB
#N   NN       NN  SS            BB         BB
#N    NN      NN  SS            BB         BB
#N     NN     NN   SSSSSSSSSSS  BBBBBBBBBBBB
#N      NN    NN            SS  BB         BB
#N       NN   NN            SS  BB         BB
#N        NN  NN            SS  BB         BB  
#N         NN NN  SSSSSSSSSSS   BBBBBBBBBBBB   :: :: ::

{
  description = "NSB's .dots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
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
        modules = [ ./hosts/odinson/configuration.nix ];
      };
    };

    darwinConfigurations = {
        l0ki = nix-darwin.lib.darwinSystem {
            specialArgs = {inherit inputs outputs;};
            pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; };
            modules = [ ./hosts/l0ki/configuration.nix ];
        };
    };

    homeConfigurations = {
      "nsbuitrago@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs nsbUser;};
        modules = [./users/nsbuitrago/odinson.nix];
      };

      "nsbuitrago@l0ki" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs nsbUser;};
        modules = [./users/nsbuitrago/l0ki.nix];
      };

      "chillwei@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs chillweiUser;};
        modules = [./users/chillwei/home.nix];
      };
    };
  };
}
