{ inputs, config, pkgs, ... }:

{
  home.username = "noraxaxv";
  home.homeDirectory = "/home/noraxaxv";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
  
  # Gnome Shell Customizations
  programs.gnome-shell.enable = true;
  programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
    { package = appindicator; }
    { package = blur-my-shell; }
    { package = dash-to-dock; }
    { package = dash-to-panel; }
    { package = tweaks-in-system-menu; }
    { package = pop-shell; }
    { package = user-themes; }
    { package = background-logo; }
  ];

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          pop-shell.extensionUuid
          appindicator.extensionUuid
          system-monitor.extensionUuid
          removable-drive-menu.extensionUuid
          places-status-indicator.extensionUuid
          blur-my-shell.extensionUuid
          dash-to-dock.extensionUuid
          #dash-to-panel.extensionUuid
          applications-menu.extensionUuid
          tweaks-in-system-menu.extensionUuid
          user-themes.extensionUuid
          background-logo.extensionUuid
        ];
      };
      
      "org/gnome/shell/extensions/user-theme" = {
        name = "Orchis-Red-Dark";
      };

      "org/gnome/desktop/interface" = {
         color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Red-Dark";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      package = pkgs.qogir-icon-theme;
      name = "Qogir-Ubuntu-Dark";
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = {
      name = "orchis";
    };
    style = { 
      name = "orchis-dark"; 
    };
  };

  # User Packages 
  home.packages = with pkgs; [
    # Studio
    blockbench
    blender
    gimp
    audacity
    musescore
    
    protonplus
    # Coding
    eclipses.eclipse-java
    lunarvim
    ptyxis
    python3
    nodejs
    openjdk
    devenv
    
    # Internet
    floorp
    tor-browser
    discord
    spotify
    libreoffice

    xorg.xkill
    gnome-tweaks
    ripgrep
    guake

    # LSP Servers
    nil
    ruff-lsp
    black
    
  ];
  
  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
    obs-backgroundremoval
    obs-pipewire-audio-capture
    advanced-scene-switcher
  ];
  
  programs.helix = {
    enable = true;
    settings = {
      theme = "adwaita-dark";
    };
    languages.language = [
      {
        name = "python";
        auto-format = true;
        formatter = {
          command = "${pkgs.ruff}/bin/ruff";
          args = ["format" "-" ];
        };
        language-servers = [ "ruff-lsp" "pyright" ];
      }
    ];
    languages.languge-server = {
      ruff-lsp = {
        command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
        config.settings.args = [ "--ignore" "E501" ];
      };
      pyright = {
        command = "${pkgs.pyright}/bin/pyright";
        args = [ "--stdio" ];
      };
    };
  };

  programs.lazygit.enable = true;
    
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "fino";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

}
