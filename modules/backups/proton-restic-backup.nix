{ pkgs, ... }:

let
  criticalRepository = "/srv/restic/critical";
  criticalPasswordFile = "/etc/restic/critical-password";

  protonEndpoint = "rest:http://127.0.0.1:8080";
in
{
  systemd.services.proton-restic-endpoint = {
    description = "Restic REST endpoint backed by Proton Drive";

    serviceConfig = {
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone \
          --config /etc/rclone/proton.conf \
          serve restic proton:/backups/critical \
          --addr 127.0.0.1:8080 \
          --protondrive-replace-existing-draft
      '';

      # We manually SIGTERM so it should be considered a success
      SuccessExitStatus = [ 143 ];

      User = "root";
      Environment = "HOME=/root";
    };
  };

  systemd.services.proton-restic-copy = {
    description = "Copy critical Restic repository to Proton Drive";

    serviceConfig = {
      Type = "oneshot";
      Environment = "HOME=/root";
      TimeoutStartSec = "infinity";

      ExecStartPre = "${pkgs.systemd}/bin/systemctl start proton-restic-endpoint.service";

      ExecStart = ''
        ${pkgs.restic}/bin/restic \
          --repo ${protonEndpoint} \
          --password-file ${criticalPasswordFile} \
          copy \
          --from-repo ${criticalRepository} \
          --from-password-file ${criticalPasswordFile}
      '';

      ExecStopPost = "${pkgs.systemd}/bin/systemctl stop proton-restic-endpoint.service";

      User = "root";
    };
  };

  systemd.timers.proton-restic-copy = {
    description = "Periodically copy critical Restic repository to Proton Drive";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "04:00";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
  };
}
