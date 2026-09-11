{ inputs, pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      libsecret
      glib
    ];
  };

  environment.systemPackages = [
    inputs.self.packages.${pkgs.system}.proton-drive-cli
  ];
}
