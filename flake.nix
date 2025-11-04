{
  description = "My nix config";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nix-unstable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    unstable-pkgs = import nix-unstable { inherit system; };
    lib = pkgs.lib.extend (_: _: {
      gpuUtils = import ./lib/gpu-utils.nix { inherit lib pkgs; };
    });
  in {
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs unstable-pkgs lib;};
        modules = [
          ./nixos/configuration.nix          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit unstable-pkgs; };
            home-manager.users = {
              cortbean = import ./home-manager/cortbean/home.nix;
              work = import ./home-manager/work/home.nix;
            };
          }
        ];
      };
    };
  };
}
