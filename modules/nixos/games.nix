{ config, lib, pkgs, ... }:

let
  gpuUtils = lib.gpuUtils;
in {
  options.my.gaming.enable = lib.mkEnableOption "Enable Steam, Lutris and gaming tools";

  config = lib.mkIf config.my.gaming.enable {
    environment.systemPackages = with pkgs; [
      (gpuUtils.GPUOffloadApp steam "steam")
      lutris
      (gpuUtils.GPUOffloadApp lutris "net.lutris.Lutris")
      prismlauncher
      (gpuUtils.GPUOffloadApp prismlauncher "org.prismlauncher.PrismLauncher")
      mangohud
      gamescope
      protonup
      wine
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = true;
    };
    
    programs.gamemode.enable = true;

    # Fix some games requiring 32-bit OpenGL
    hardware.graphics.enable32Bit = true;

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };
}
