{ ... }:

{
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
