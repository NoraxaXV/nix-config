# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "noraxaxv";
    homeDirectory = "/home/noraxaxv";
    sessionVariables = {
      SSH_ASKPASS = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
      SSH_ASKPASS_REQUIRE = "prefer";
    };
  };
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

    shellAliases = {
      update-os = "sudo nixos-rebuild switch --flake .";
      update-home = "home-manager switch --flake .";
      logout-kde = "qdbus org.kde.KWin /Session org.kde.KWin.Session.quit";
    };
    oh-my-zsh = {
      enable = true;
      theme = "fino";
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

  home.packages = with pkgs; [
    floorp
    upscayl
    blender
    audacity
    gimp
    kdePackages.kdenlive
    kdePackages.ksshaskpass
    haruna
    musescore
    protonup-qt
    mangohud
    discord
    spotify
    lutris
    devenv
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];
      # Change Java runtimes available to Prism Launcher
      jdks = [ zulu8 zulu17 zulu23 zulu ];
    })
    gh

    # Fonts
    nerd-fonts.hack
    nerd-fonts.fira-mono
    orbitron
    fira
  ];
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
