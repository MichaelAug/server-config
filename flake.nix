{
  description = "Home server";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      username = "server";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        specialArgs = {
          username = username;
        };

        modules = nixpkgs.lib.filesystem.listFilesRecursive ./modules;
      };

      # Tools to work with this repo. Run `nix develop` to use
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd # Nix language server
          nil # Another nix language server
          nixfmt-tree # Formatter for Nix code
          statix # Lints and suggestions for Nix
          deadnix # Find dead code
          nh # Nix command helper
        ];
      };
    };
}
