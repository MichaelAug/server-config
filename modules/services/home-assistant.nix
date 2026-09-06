{ ... }:

{
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "default_config"
      "homekit"
      "mobile_app"
      "mqtt"
      "webhook"
      "zeroconf"
    ];
  };
}
