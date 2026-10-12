#NNNN         NN   SSSSSSSSSSS  BBBBBBBBBBBB
#N  NN        NN  SS            BB         BB
#N   NN       NN  SS            BB         BB
#N    NN      NN  SS            BB         BB
#N     NN     NN   SSSSSSSSSSS  BBBBBBBBBBBB
#N      NN    NN            SS  BB         BB
#N       NN   NN            SS  BB         BB
#N        NN  NN            SS  BB         BB  
#N         NNNNN  SSSSSSSSSSS   BBBBBBBBBBBB   :: :: ::

{
  description = "NSB's .dots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    tailscale.url = "https://flakehub.com/f/tailscale/tailscale/1.90.6";

    noctalia.url = "github:noctalia-dev/noctalia/cachix";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    tailscale,
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

    homeConfigurations = {
      "nsbuitrago@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs nsbUser;};
        modules = [./users/nsbuitrago/odinson.nix];
      };

      "chillwei@odinson" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs chillweiUser;};
        modules = [./users/chillwei/home.nix];
      };
    };
  };
}
