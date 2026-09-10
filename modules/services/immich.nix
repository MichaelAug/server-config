{ ... }:

{
  # Create media directory if it doesn't exist
  systemd.tmpfiles.rules = [
    "d /srv/immich 0750 immich users -"
  ];

  services.immich = {
    enable = true;

    host = "127.0.0.1";
    port = 2283;

    mediaLocation = "/srv/immich";

    # Allow Immich to access the Intel GPU for transcoding.
    accelerationDevices = null;
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];
}
