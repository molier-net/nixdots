{
  description = "Molier.NET NixOS configuration";

  inputs = {
    # NixPkgs 24.05
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # NixPkgs unstable
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall lib
    snowfall-lib = {
      url = "github:molier-net/snowfall-lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "molier-net/nixdots";
            title = "Molier.NET Nix Configurations";
          };

          namespace = "nixdots";
        };
      };
    in 
    lib.mkFlake {
      
      channels-config = {
        allowUnfree = true;
      };

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
      ];
    };
}
