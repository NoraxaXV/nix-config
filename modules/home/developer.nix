{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption  mkOption types;
  cfg = config.profiles.developer;
in {
  options = {
    profiles.developer = {
      enable = mkEnableOption "";
      zsh.enable = mkEnableOption "";
      git.enable = mkEnableOption "";
      vscode.enable = mkEnableOption "";
      helix = {
        enable = mkEnableOption "";
        theme = mkOption {
          type = types.string;
          default = "material_darker";
        };
      };
      ghostty.enable = mkEnableOption "";  
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nil devenv ];
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
    home.file."~/.p10k.zsh".source = ./.p10k.zsh;

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
