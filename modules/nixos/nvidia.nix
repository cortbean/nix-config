{ config, ... }:
{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = true;

    open = true;
    # Enable the Nvidia settings menu,
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
