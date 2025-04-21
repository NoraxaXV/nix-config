{ lib, config, ... }:
let
  cfg = config.avalon.nvidia;
  busIdType = lib.types.strMatching
    "([[:print:]]+:[0-9]{1,3}(@[0-9]{1,10})?:[0-9]{1,2}:[0-9])?";
in {
  options.avalon.nvidia = {
    enable = lib.mkEnableOption "NVIDIA Options";

    enableSync = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether to enable prime sync, uses offloading by default.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.nvidiaPackages.latest;
      description = ''
        NVIDIA Package to use. Defaults to the latest driver.
      '';
    };

    intelBusId = lib.mkOption {
      type = busIdType;
      default = "";
      example = "PCI:0:2:0";
    };

    nvidiaBusId = lib.mkOption {
      type = busIdType;
      default = "";
      example = "PCI:0:1:0";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "i915" "nvidia" ];

    hardware.graphics.enable = true;
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      package = cfg.package;
      prime = lib.mkMerge [
        {
          intelBusId = cfg.intelBusId;
          nvidiaBusId = cfg.nvidiaBusId;
          offload = lib.mkAfter {
            enable = true;
            enableOffloadCmd = true;
          };
        }
        lib.mkIf
        cfg.enableSync
        {
          offload = lib.mkBefore {
            enable = false;
            enableOffloadCmd = false;
          };
          sync.enable = true;
        }
      ];
    };
  };
}
