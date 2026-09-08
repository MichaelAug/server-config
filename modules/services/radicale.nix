{ ... }:

{
  services.radicale = {
    enable = true;

    settings = {
      server.hosts = [
        "127.0.0.1:5232"
      ];

      auth = {
        type = "htpasswd";
        htpasswd_filename = "/var/lib/radicale/users";
        htpasswd_encryption = "bcrypt";
      };

      rights.type = "owner_only";

      storage.filesystem_folder = "/var/lib/radicale/collections";
    };
  };
}
