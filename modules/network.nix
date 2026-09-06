{ ... }:

{
  networking = {
    networkmanager.enable = true;
    hostName = "n150";
    firewall.enable = true;
    interfaces.enp2s0.useDHCP = true;
  };
}
