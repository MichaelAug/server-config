{ lib, pkgs, ... }:

let
  frigateConfig = ../../frigate.yml;
  passwordFile = "/var/lib/home-automation/password";
  frigateEnvironmentFile = "/run/frigate/env";
in
{
  virtualisation.podman.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";

    containers.frigate = {
      image = "ghcr.io/blakeblackshear/frigate:0.17.2";

      ports = [
        "127.0.0.1:80:8971"
      ];

      volumes = [
        "/var/lib/frigate/config:/config"
        "/mnt/backup/frigate:/media/frigate"
      ];

      environment = {
        TZ = "Europe/London";
      };

      environmentFiles = [
        frigateEnvironmentFile
      ];

      extraOptions = [
        "--device=/dev/dri/renderD128:/dev/dri/renderD128"
        "--shm-size=256m"
      ];
    };
  };

  systemd.services.podman-frigate = {
    after = [ "mosquitto.service" ];
    wants = [ "mosquitto.service" ];
    unitConfig = {
      RequiresMountsFor = "/mnt/backup";
      ConditionPathIsMountPoint = "/mnt/backup";
    };
  };

  # Seed the config once; subsequent edits are managed in Frigate's UI.
  systemd.services.podman-frigate.preStart = lib.mkBefore ''
    install -d -m 0750 /var/lib/frigate
    install -d -m 0750 /var/lib/frigate/config
    if ! ${pkgs.util-linux}/bin/mountpoint -q /mnt/backup; then
      echo "Frigate recording HDD is not mounted" >&2
      exit 1
    fi
    install -d -m 0750 /mnt/backup/frigate

    if [ ! -s ${passwordFile} ]; then
      echo "Missing ${passwordFile}" >&2
      exit 1
    fi

    if [ ! -e /var/lib/frigate/config/config.yml ]; then
      install -m 0640 ${frigateConfig} /var/lib/frigate/config/config.yml
    fi

    install -d -m 0750 /run/frigate

    umask 077
    printf 'FRIGATE_PASSWORD=%s\n' \
      "$(cat ${passwordFile})" \
      > ${frigateEnvironmentFile}

    chmod 0600 ${frigateEnvironmentFile}
  '';
}
