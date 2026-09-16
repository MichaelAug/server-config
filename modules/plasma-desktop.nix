{ pkgs, username, ... }:

{
  services = {
    xserver.enable = false;

    desktopManager.plasma6.enable = true;

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };

      autoLogin = {
        enable = true;
        user = username;
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

  };

  programs.moonlight-qt.enable = true;

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
}
