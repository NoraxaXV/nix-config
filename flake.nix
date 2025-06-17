{
  description = "NixOS Excalibur Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-nebula.url = "github:JustAdumbPrsn/Nebula-A-Minimal-Theme-for-Zen-Browser";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    mkNixosSystem = {
      config,
      home,
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules =
          [
            config
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.useGlobalPkgs = true;
              home-manager.users.noraxaxv = home;
            }
          ]
          ++ extraModules;
      };
  in {
    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosConfigurations = {
      excalibur = mkNixosSystem {
        config = ./hosts/excalibur/configuration.nix;
        home = ./hosts/excalibur/home.nix;
      };

      mistilteinn = mkNixosSystem {
        config = ./hosts/mistilteinn/configuration.nix;
        home = ./hosts/mistilteinn/home.nix;
      };
    };

    homeConfigurations = {
      "noraxaxv@caladbolg" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [./hosts/caladbolg/home.nix];
      };
    };
  };
}
