{
  inputs =
  {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    zsh-nix-shell =
    {
      url = "github:chisui/zsh-nix-shell/master";
      flake = false;
    };
    zen-browser =
    {
      url = "github:0xc000022070/zen-browser-flake";
      inputs =
      {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    home-manager =
    {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix =
    {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia =
    {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    blissify-rs-src =
    {
      url = "github:Polochon-street/blissify-rs";
      flake = false;
    };
    nixgl =
    {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs
    {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable
    {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.nixos-hypr = nixpkgs.lib.nixosSystem
    {
      inherit system;

      specialArgs =
      {
        inherit inputs pkgs-unstable;
      };
      modules =
      [
        {
          nixpkgs.overlays =
          [
            inputs.nur.overlays.default
          ];
          nixpkgs.config.allowUnfree = true;
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.users.lgalloux = import ./home-modules/home.nix; 
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs =
          {
            inherit inputs pkgs-unstable;
          };
        }
        home-manager.nixosModules.home-manager
        ./configuration.nix
      ];
    };
    homeConfigurations.lgalloux = home-manager.lib.homeManagerConfiguration
    {
       inherit pkgs;
      extraSpecialArgs =
      {
        inherit inputs
        pkgs-unstable;
        osConfig =
        {
          networking.hostName = "standalone-pc";
        };
      };
      modules =
      [
        ./home-modules/home.nix
        {
          nixpkgs.overlays =
          [
            inputs.nur.overlays.default
          ];
        }
      ];
    };
  };
}
