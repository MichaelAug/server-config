{ pkgs, ... }:
let
  frigateModel = pkgs.stdenvNoCC.mkDerivation {
    pname = "frigate-openvino-model";
    version = "0.17.2";

    src = ../../openvino-model;

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    intel-compute-runtime
    level-zero
  ];

  systemd.services.frigate.environment = {
    OCL_ICD_VENDORS = "${pkgs.intel-compute-runtime}/etc/OpenCL/vendors";
  };

  services.frigate = {
    enable = true;
    hostname = "frigate";

    settings = {
      mqtt.enabled = false;

      ffmpeg.hwaccel_args = "preset-vaapi";

      detectors.ov = {
        type = "openvino";
        device = "GPU";
      };

      model = {
        width = 300;
        height = 300;
        input_tensor = "nhwc";
        input_pixel_format = "bgr";
        path = "${frigateModel}/ssdlite_mobilenet_v2.xml";
        labelmap_path = "${frigateModel}/coco_91cl_bkgr.txt";
      };

      cameras.outside = {
        ffmpeg.inputs = [
          {
            path = "rtsp://admin:CAMERA_PASSWORD@192.168.0.239:554/Preview_01_sub";
            roles = [ "detect" ];
          }
          {
            path = "rtsp://admin:CAMERA_PASSWORD@192.168.0.239:554/Preview_01_main";
            roles = [ "record" ];
          }
        ];

        detect = {
          width = 640;
          height = 480;
          fps = 5;
        };

        record.enabled = true;
      };
    };
  };

  services.nginx.virtualHosts.frigate.serverAliases = [
    "n150.tail617a34.ts.net"
  ];
}
