{ ... }:
{
  services.tailscale.enable = true;

  networking.firewall = {
    # Syncthing sync traffic — Tailscale only
    interfaces.tailscale0.allowedTCPPorts = [
      22000 # Syncthing
      8384 # Syncthing GUI
    ];

    interfaces.tailscale0.allowedUDPPorts = [
      22000 # Syncthing QUIC
    ];
  };
}
