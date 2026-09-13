{ pkgs, ... }:

let
  criticalRepository = "/srv/restic/critical";
  criticalPasswordFile = "/etc/restic/critical-password";

  otherRepository = "/srv/restic/other";
  otherPasswordFile = "/etc/restic/other-password";

  sshRepository = "sftp:restic@nix-desktop:/srv/restic";
in
{
  # IMPORTANT: restic copy does not prune old generations, nothing handles this for now

  systemd.services.restic-copy-ssh = {
    description = "Copy Restic backups over SSH";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Environment = "HOME=/root";
      TimeoutStartSec = "2h";

      ExecStart = [
        "${pkgs.restic}/bin/restic --repo ${sshRepository}/critical --password-file ${criticalPasswordFile} copy --from-repo ${criticalRepository} --from-password-file ${criticalPasswordFile}"
        "${pkgs.restic}/bin/restic --repo ${sshRepository}/other --password-file ${otherPasswordFile} copy --from-repo ${otherRepository} --from-password-file ${otherPasswordFile}"
      ];
    };
  };

  systemd.timers.restic-copy-ssh = {
    description = "Periodically copy Restic repositories over SSH";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "11:30";
      RandomizedDelaySec = "30m";
      Persistent = true;
    };
  };
}
