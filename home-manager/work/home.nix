{ config, pkgs, ... }:

{
  home.username = "work";
  home.homeDirectory = "/home/work";

  home.stateVersion = "25.05";

  programs.zsh.enable = true;

  home.packages = with pkgs; [
    nodejs
    vscodium
    teams-for-linux
    firefox
  ];
}
