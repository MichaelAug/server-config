{ lib, pkgs, ... }:

let
  hacsArchive = pkgs.fetchurl {
    url = "https://github.com/hacs/integration/releases/download/2.0.5/hacs.zip";
    sha256 = "04zlmn3k0ylq7cdqnhj31anqnsvz6rrdvilcfa1ycf2g9a16pglp";
  };
  hacs = pkgs.runCommand "hacs-2.0.5" { nativeBuildInputs = [ pkgs.unzip ]; } ''
    mkdir -p "$out"
    unzip -q ${hacsArchive} -d "$out"
    test -f "$out/manifest.json"
  '';
in
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

      # Seed HACS once; subsequent updates are managed through HA.
      # TODO: Replace HACS provisioning with native Marketplace for HA 2026.11+,
      if [ ! -e /var/lib/home-assistant/custom_components/hacs ]; then
        install -d -m 0700 /var/lib/home-assistant/custom_components
        hacsTmp=$(mktemp -d /var/lib/home-assistant/custom_components/.hacs.XXXXXX)
        cp -R ${hacs}/. "$hacsTmp/"
        chmod -R u+rwX "$hacsTmp"
        mv "$hacsTmp" /var/lib/home-assistant/custom_components/hacs
      fi
    '';
    serviceConfig.TimeoutStopSec = lib.mkForce 90;
  };
}
