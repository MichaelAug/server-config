{ pkgs, username, ... }:

{
  services.xserver.enable = true;

  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-bigscreen
    vacuum-tube
    firefox
    kodi

    # Dev
    zed-editor
    helix
    git
  ];

  hardware.graphics.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
