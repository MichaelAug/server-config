{ pkgs, ... }:

{
  services.nextcloud = {
    enable = true;

    hostName = "n150.tail617a34.ts.net";
    package = pkgs.nextcloud34;
    database.createLocally = true;
    config = {
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "pgsql";
    };

    appstoreEnable = true;
    configureRedis = true;

    settings = {
      trusted_domains = [
        "n150.tail617a34.ts.net"
      ];

      overwriteprotocol = "https";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
  ];
}
