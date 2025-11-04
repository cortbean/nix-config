# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  outputs,
  lib,
  pkgs,
  ...
}:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Import Modules
      outputs.nixosModules.nvidia
      outputs.nixosModules.games
    ];

  # Activate modules
  my.gaming.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "preempt=voluntary" ];

  networking.hostName = "nixos"; # Define your hostname.

  services.fwupd.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ca";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "cf";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cortbean = {
    isNormalUser = true;
    description = "cortbean";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "adbusers" "docker" ];
  };

  users.users.work = {
    isNormalUser = true;
    description = "work";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" ];
  };

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #Installing Zsh
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
    vlc
    pavucontrol
    qjackctl
    home-manager
    gparted
    git
    ungoogled-chromium
    onlyoffice-desktopeditors
    wget
    lshw
    nh
    zsh
    thefuck
    tmux
    nixd
    nixfmt-rfc-style
    imagemagick
    ghostscript
    texlive.combined.scheme-full
    thunderbird
    kdePackages.merkuro
    kdePackages.kdepim-addons
    kile
    (bottles.override{removeWarningPopup = true;})
    android-studio
    wl-clipboard
    freerdp
    remmina
  ];

  programs.adb.enable = true;

  programs.kdeconnect.enable = true;
  virtualisation.waydroid.enable = true;

  #Configuing NH
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5";
    flake = "/home/cortbean/Documents/nix-config";
  };

  virtualisation.docker.enable = true;

  #Virtualisation
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["cortbean"];
  users.groups.kvm.members = ["cortbean"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;

  systemd.services.libvirtd.serviceConfig.Environment = [
  "LIBGL_DRIVERS_PATH=/run/opengl-driver/lib/dri"
  "LIBGL_ALWAYS_INDIRECT=1"
];

  system.stateVersion = "25.05"; # Did you read the comment?
}
