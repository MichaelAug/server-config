{ username, ... }:
{
  services.syncthing = {
    enable = true;

    settings = {
      options = {
        globalAnnounceEnabled = false;
        relaysEnabled = false;
      };
    };

    user = username;
    openDefaultPorts = true;
    dataDir = "/home/${username}/Sync"; # Default folder for new synced folders
    configDir = "/home/${username}/.config/syncthing"; # Folder for Syncthing's settings and keys
  };
}
