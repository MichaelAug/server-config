{ lib, ... }:

{
  # Make sure NixOS HA is not enabled, we're using a container
  services.home-assistant.enable = lib.mkForce false;

  virtualisation.podman.enable = true;
  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:2026.10.4";
      environment.TZ = "Europe/London";
      volumes = [
        "/var/lib/home-assistant:/config"
        "/run/dbus:/run/dbus:ro"
      ];
      extraOptions = [
        "--network=host"
        "--cap-add=NET_ADMIN"
        "--cap-add=NET_RAW"
        "--stop-timeout=60"
      ];
    };
  };

  systemd.services.podman-homeassistant = {
    after = [ "bluetooth.service" ];
    wants = [ "bluetooth.service" ];
    preStart = lib.mkBefore ''
      install -d -m 0700 /var/lib/home-assistant
    '';
    serviceConfig.TimeoutStopSec = lib.mkForce 90;
  };
}
