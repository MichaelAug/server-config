{ ... }:

{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "0.0.0.0";
        port = 1883;
        settings.allow_anonymous = false;
        users = {
          frigate = {
            passwordFile = "/var/lib/home-automation/password";
            acl = [ "readwrite frigate/#" ];
          };
          homeassistant = {
            passwordFile = "/var/lib/home-automation/password";
            acl = [ "readwrite frigate/#" ];
          };
        };
      }
    ];
  };

  # HA uses localhost through host networking.
  # Frigate reaches the host through Podman's default bridge
  networking.firewall.interfaces.podman0.allowedTCPPorts = [ 1883 ];
}
