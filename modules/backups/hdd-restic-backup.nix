{ pkgs, ... }:

let
  criticalRepository = "/srv/restic/critical";
  personalRepository = "/srv/restic/personal";
  criticalPasswordFile = "/etc/restic/critical-password";

  otherRepository = "/srv/restic/other";
  otherPasswordFile = "/etc/restic/other-password";

  hddMount = "/mnt/backup";
in
{
  # Mount the external Btrfs backup drive at /mnt/backup.
  #
  # "nofail" means the server can still boot if the HDD is unplugged.
  fileSystems."/mnt/backup" = {
    device = "UUID=cc6c2ee8-67ac-4c26-9f6c-2ed5840bfa65";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

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

        "${pkgs.restic}/bin/restic --repo ${hddMount}/personal --password-file ${criticalPasswordFile} copy --from-repo ${personalRepository} --from-password-file ${criticalPasswordFile}"
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
