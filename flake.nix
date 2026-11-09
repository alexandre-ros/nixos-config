{
  description = "My personal Nix configuration ❄️";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # only to enable noctalia (hm unstable)
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    mkHost = {
      hostname,
      hardwareModule,
      username,
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs pkgs-unstable hostname;};

        modules = [
          ./nixos/common.nix
          hardwareModule
          home-manager.nixosModules.home-manager
          {
            home-manager.backupFileExtension = "bak";
            home-manager.extraSpecialArgs    = {inherit inputs pkgs-unstable hostname;};
            home-manager.overwriteBackup     = true;
            home-manager.useGlobalPkgs       = true;
            home-manager.useUserPackages     = true;
            home-manager.users.${username}   = import ./home/default.nix;
          }
        ];
      };
  in {
    # NixOS configuration entrypoint
    nixosConfigurations = {
      Termina = mkHost {
        hostname = "Termina";
        hardwareModule = ./hardware/Termina.nix;
        username = "alex";
      };
      Hyrule = mkHost {
        hostname = "Hyrule";
        hardwareModule = ./hardware/Hyrule.nix;
        username = "alex";
      };
    };
  };
}
