{ pkgs, ... }:

{
  services.nextcloud = {
    enable = true;

    hostName = "192.168.0.91";
    package = pkgs.nextcloud34;
    database.createLocally = true;
    config = {
      adminuser = "admin";
      adminpassFile = "/etc/nextcloud-admin-pass";
      dbtype = "pgsql";
    };

    configureRedis = true;

    settings = {
      trusted_domains = [
        "192.168.0.91"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
  ];

  services.postgresql.enable = true;

  services.redis.servers.nextcloud.enable = true;
}
