{ config, pkgs, lib, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "cortbean";
  home.homeDirectory = "/home/cortbean";

  # Enables bitwarden SSH Agent
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    floorp
    megasync
    obsidian
    discord
    bitwarden-desktop
  ];
  
  programs.vscode = {
  enable = true;
  package = pkgs.vscodium;
  profiles.default.extensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    ];
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "cortbean";
    userEmail = "medestjean@outlook.com";
    lfs.enable = true;

    signing = {
      signByDefault = true;
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEMQG4wn1DRSWsrucUW3lO6ZTztjf+dej7Nnhn/fR1O7";
    };
  };

  #starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
    };

    shellAliases = {
      f = "fuck";
    };
    history.size = 10000;

    initContent = ''
      eval "$(starship init zsh)"
    '';
  };

  home.stateVersion = "25.05";
}
