{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.shell-tools;
in
{
  options = {
   shell-tools.enable = lib.mkEnableOption ""; 
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "NoraxaXV";
      userEmail = "kurororbm@gmail.com";
    };
    programs.lazygit.enable = true;
    services.ssh-agent.enable = true;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [{
        name = "powerline10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }];
      initContent = ''
        source ~/.p10k.zsh
      '';
      shellAliases = {
        update-os = "sudo nixos-rebuild switch --flake .";
        update-home = "home-manager switch --flake .";
        logout-kde = "qdbus org.kde.KWin /Session org.kde.KWin.Session.quit";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "dirhistory" "history" ];
      };
    };
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      attachExistingSession = true;
      settings = {
        theme = "nord";
        show_startup_tips = false;
        #default_layout = "classic";
        #default_mode = "locked";
      };
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.helix = {
      enable = true;
      settings = { theme = "material_darker"; };
      languages.language = [{
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
     }];
    };
  };
}
