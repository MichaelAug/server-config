{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.self.packages.${pkgs.system}.proton-drive-cli
  ];
}
