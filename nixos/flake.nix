{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    niri.url = "github:sodiboo/niri-flake";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, niri, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        niri.nixosModules.niri
        home-manager.nixosModules.home-manager
        ./configuration.nix
      ];
    };
  };
}
