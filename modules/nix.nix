{ ... }:

{
  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary software.
  };

  nix.settings = {
    auto-optimise-store = true;

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    keep-outputs = false;
    keep-derivations = false;

    max-jobs = "auto";
    cores = 0;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
