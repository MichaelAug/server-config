{ pkgs, ... }:

{
  # Install the Restic CLI so it is available for manual restores,
  # repository checks, snapshots, etc.
  environment.systemPackages = [
    pkgs.restic
  ];

  systemd.tmpfiles.rules = [
    # Restic repositories stored on the internal SSD.
    #
    # Critical and other are managed locally by root.
    # Personal is populated remotely over SFTP by the server user.
    "d /srv/restic 0750 server users -"
    "d /srv/restic/personal 0700 server users -"

    "d /srv/restic/critical 0700 root root -"
    "d /srv/restic/other 0700 root root -"
  ];

  services.restic.backups = {
    # Critical backup repository.
    #
    # Contains data that is particularly important to preserve
    critical = {
      # Restic repository stored on the internal SSD
      repository = "/srv/restic/critical";
      passwordFile = "/etc/restic/critical-password";

      paths = [
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
      # Restic repository stored on the internal SSD.
      repository = "/srv/restic/other";

      # Separate password from the Critical repository.
      passwordFile = "/etc/restic/other-password";

      paths = [
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
