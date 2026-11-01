{ pkgs, username, ... }:

{
  services = {
    xserver.enable = false;

    desktopManager.plasma6.enable = true;

    displayManager = {
      defaultSession = "plasma-bigscreen-wayland";
      sessionPackages = [ pkgs.kdePackages.plasma-bigscreen ];

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

  # Always start fresh, even if the user previously enabled session restoration.
  environment.etc."xdg/ksmserverrc".text = ''
    [General]
    loginMode[$i]=emptySession
  '';

  # Let Bigscreen's controller handler emulate keyboard/mouse input without
  # prompting at every login.
  systemd.user.services.bigscreen-input-permission = {
    description = "Authorize Plasma Bigscreen controller input";
    wantedBy = [ "graphical-session-pre.target" ];
    before = [ "graphical-session-pre.target" ];
    unitConfig.ConditionUser = username;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak permission-set kde-authorized remote-desktop org.kde.plasma.bigscreen.inputhandler yes";
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-bigscreen
    kdePackages.plasma-keyboard
    vacuum-tube
    firefox
    kodi
    zed-editor
  ];
}
