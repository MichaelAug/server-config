{ pkgs, ... }:

let
  criticalRepository = "/srv/restic/critical";
  criticalPasswordFile = "/etc/restic/critical-password";

  otherRepository = "/srv/restic/other";
  otherPasswordFile = "/etc/restic/other-password";

  hddMount = "/mnt/backup";
in
{
  systemd.services.restic-copy-hdd = {
    description = "Replicate Restic repositories to HDD";

    # Only run when the external HDD is actually mounted.
    # The SSD repositories remain the primary backup destination.
    unitConfig = {
      ConditionPathIsMountPoint = hddMount;
    };

    serviceConfig = {
      Type = "oneshot";
      Environment = "HOME=/root";

      ExecStart = [
        "${pkgs.restic}/bin/restic --repo ${hddMount}/critical --password-file ${criticalPasswordFile} copy --from-repo ${criticalRepository} --from-password-file ${criticalPasswordFile}"

        "${pkgs.restic}/bin/restic --repo ${hddMount}/other --password-file ${otherPasswordFile} copy --from-repo ${otherRepository} --from-password-file ${otherPasswordFile}"
      ];
    };
  };

  systemd.timers.restic-copy-hdd = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "03:00";
    };
  };
}
