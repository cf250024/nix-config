{
  description = "NixOS System config with flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, blender-bin, home-manager, ... }: 
  let
    system = "aarch64-linux";
    username = "nixos";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      configuration = {
        imports = [
          ./home.nix
        ];
        nixpkgs.overlays = [blender-bin.overlays.default];
      };

      inherit system username;
      homeDirectory = "/home/${username}";
      # Update the state version as needed.
      stateVersion = "22.05";
    };


    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
