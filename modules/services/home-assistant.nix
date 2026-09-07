{ ... }:

{
  # HTTP/reverse-proxy settings are configured through the HA UI:
  #
  # Settings → System → Network → HTTP server
  #
  # Required because HA 2026.8 moved these settings out of
  # configuration.yaml:
  #   Trust X-Forwarded-For: ON
  #   Trusted proxies: 127.0.0.1
  #
  # HA listens on HTTP :8123; HTTPS is terminated by the
  # reverse proxy/Tailscale layer on :8444.
  services.home-assistant = {
    enable = true;

    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };

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
