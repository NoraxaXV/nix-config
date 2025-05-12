{ inputs, lib, config, pkgs, ... }: {

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
      theme = "ao";
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

  home.packages = with pkgs; [
    floorp
    upscayl
    blender
    audacity
    gimp
    kdePackages.kdenlive
    kdePackages.ksshaskpass
    kdePackages.qtstyleplugin-kvantum
    kde-rounded-corners
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
    inter
  ];
  fonts.fontconfig.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vkcapture
      obs-pipewire-audio-capture
      obs-mute-filter
    ];
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
