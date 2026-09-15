{ lib, pkgs, ... }:

{
  programs = {
    gamescope.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;

      gamescopeSession.enable = true;


    };
  };

  services.displayManager.sessionPackages = [
    ((pkgs.writeTextDir "share/wayland-sessions/steam.desktop" ''
      [Desktop Entry]
      Name=Steam
      Comment=Steam Big Picture Mode
      Exec=${lib.getExe pkgs.gamescope} -W 3840 -H 2160 -f -e -- steam
      Type=Application
    '').overrideAttrs {
      passthru.providedSessions = [ "steam" ];
    })
  ];
}
