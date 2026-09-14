{ lib, pkgs, username, ... }:

{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  services = {
    xserver.enable = false;

    greetd = {
      enable = true;

      settings.default_session = {
        command = "${lib.getExe pkgs.gamescope} -W 3840 -H 2160 -f -e -- steam";
        user = username;
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    kodi
    vacuum-tube
  ];
}
