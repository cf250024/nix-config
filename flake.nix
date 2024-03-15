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
      modules = [
        ./users/nixos/home.nix
        {
          nixpkgs.overlays = [blender-bin.overlays.default];
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            # Update the state version as needed.
            stateVersion = "23.11";
          };
        }
      ];
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
