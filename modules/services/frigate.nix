{ lib, ... }:

let
  frigateConfig = ../../frigate.yml;
  cameraPasswordFile = "/var/lib/frigate/camera_password";
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
        "/var/lib/frigate/media:/media/frigate"
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

  # NOTE: frigate.yml config will only be copied if it doesn't exist in /var/lib/frigate/config/
  systemd.services.podman-frigate.preStart = lib.mkBefore ''
    install -d -m 0750 /var/lib/frigate
    install -d -m 0750 /var/lib/frigate/config
    install -d -m 0750 /var/lib/frigate/media

    if [ ! -e ${cameraPasswordFile} ]; then
      echo "Missing ${cameraPasswordFile}" >&2
      exit 1
    fi

    if [ ! -e /var/lib/frigate/config/config.yml ]; then
      install -m 0640 ${frigateConfig} /var/lib/frigate/config/config.yml
    fi

    install -d -m 0750 /run/frigate

    printf 'FRIGATE_RTSP_PASSWORD=%s\n' \
      "$(cat ${cameraPasswordFile})" \
      > ${frigateEnvironmentFile}

    chmod 0600 ${frigateEnvironmentFile}
  '';
}
