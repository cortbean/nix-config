{ config, pkgs, ... }:

{
  home.username = "work";
  home.homeDirectory = "/home/work";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nodejs
    vscode
    teams-for-linux
    firefox
    pgadmin4
  ];

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
  };
}
