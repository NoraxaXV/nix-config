{ config, pkgs, ... }: {
  imports = [ ../../home-modules/shell-tools.nix ];
  home = {
    username = "noraxaxv";
    homeDirectory = "/home/noraxaxv";
    stateVersion = "25.05";
  };
  shell-tools.enable = true;
  home.packages = with pkgs; [ nerd-fonts.fira-mono ];
  programs.home-manager.enable = true;
}
