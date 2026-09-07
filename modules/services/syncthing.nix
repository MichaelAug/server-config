{ username, ... }:
{
  # Syncthing is configured to communicate exclusively over Tailscale.
  #
  # Devices use their Syncthing Device IDs for authentication and Tailscale
  # MagicDNS hostnames for connectivity. LAN discovery, global discovery,
  # and Syncthing relays are disabled.
  #
  # This is a declarative config; changes made in the Syncthing UI
  # will be discarded on restart/rebuild.
  services.syncthing = {
    enable = true;

    settings = {
      options = {
        globalAnnounceEnabled = false;
        localAnnounceEnabled = false;
        relaysEnabled = false;
      };

      devices = {
        nix-desktop = {
          id = "I4Y4H4X-LZMBUBF-UAPMDN3-NCAPT74-X3CTQKM-PEUE6LC-A2FAUSZ-LAOUBQ4";
          addresses = [ "tcp://nix-desktop:22000" ];
        };

        michaels-s24 = {
          id = "F4MJPRA-CQSC637-MQATXCI-NTZR3MV-BBZORV4-RTVOTNN-W4XXCDE-LZLT7AI";
          addresses = [ "tcp://michaels-s24:22000" ];
        };
      };

      folders = {
        documents = {
          path = "/home/${username}/Sync/Documents";
          type = "receiveonly";
          order = "oldestFirst";
          versioning.type = "staggered";
          devices = [
            "nix-desktop"
            "michaels-s24"
          ];
        };
      };
    };

    # Expose the GUI over Tailscale; firewall restricts access to tailscale0.
    guiAddress = "0.0.0.0:8384";

    user = username;
    group = "syncthing";

    openDefaultPorts = false;
    dataDir = "/home/${username}/Sync";
    configDir = "/home/${username}/.config/syncthing";
  };
}
