{ pkgs, ... }:

{
  # Mount the external Btrfs backup drive at /mnt/backup.
  #
  # "nofail" means the server can still boot if the HDD is unplugged.
  # Restic jobs will only work when the drive is actually mounted.
  fileSystems."/mnt/backup" = {
    device = "UUID=cc6c2ee8-67ac-4c26-9f6c-2ed5840bfa65";
    fsType = "btrfs";
    options = [ "nofail" ];
  };

  # Install the Restic CLI so it is available for manual restores,
  # repository checks, snapshots, etc.
  environment.systemPackages = [
    pkgs.restic
  ];

  # Create the directories used for manually managed backup material.
  #
  # The Restic repositories live on the host's internal SSD. They are
  # subsequently replicated to the external HDD and, later, another
  # NixOS machine over SSH.
  systemd.tmpfiles.rules = [
    "d /backup 0750 server users -"
    "d /backup/personal 0750 server users -"
    "d /backup/personal/critical 0750 server users -"
    "d /backup/personal/other 0750 server users -"

    # Primary Restic repositories on the internal SSD.
    #
    # These contain encrypted Restic data and should only be accessible
    # by root, since the Restic services run as root by default.
    "d /srv/restic 0700 root root -"
    "d /srv/restic/critical 0700 root root -"
    "d /srv/restic/other 0700 root root -"
  ];

  services.restic.backups = {
    # Critical backup repository.
    #
    # Contains data that is particularly important to preserve
    critical = {
      # Restic repository stored on the external .
      repository = "/srv/restic/critical";
      passwordFile = "/etc/restic/critical-password";

      paths = [
        # Manually selected critical personal files.
        "/backup/personal/critical"

        # Radicale's persistent data, including calendars,
        # contacts and its authentication data.
        "/var/lib/radicale"

        # Actual user data managed by Syncthing.
        # Syncthing's configuration/database itself is not backed up
        # because the service configuration is declarative in NixOS.
        "/home/server/Sync/Documents"
      ];

      # Run the critical backup at 02:30 every day.
      timerConfig = {
        OnCalendar = "02:30";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 1"
      ];
    };

    # Other backup repository.
    #
    # Used for larger / less critical data. Currently this includes
    # the useful parts of the Immich data.
    other = {
      # Restic repository stored on the external HDD.
      repository = "/srv/restic/other";

      # Separate password from the Critical repository.
      passwordFile = "/etc/restic/other-password";

      paths = [
        # Manually selected non-critical personal files.
        "/backup/personal/other"

        # Immich's PostgreSQL database backups created by Immich itself.
        "/srv/immich/backups"

        # Immich asset directories that should be preserved.
        "/srv/immich/library"
        "/srv/immich/profile"
        "/srv/immich/upload"
      ];

      # Run after Immich's automatic database backup at 02:00.
      # This gives Immich time to finish creating the database backup
      # before Restic captures /srv/immich/backups.
      timerConfig = {
        OnCalendar = "02:15";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 1"
      ];
    };
  };
}
