{ pkgs, ... }:

{
  # Disable split-lock mitigation to avoid its performance overhead.
  boot.kernelParams = [
    "split_lock_mitigate=0"
  ];

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.enableRedistributableFirmware = true;
}
