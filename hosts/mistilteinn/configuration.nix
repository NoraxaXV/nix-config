{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  networking.hostName = "mistilteinn"; 
  networking.networkmanager.enable = true;
  
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb.layout = "us";
  services.libinput.enable = true;
  time.timeZone = "America/Indianapolis";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; 
  };
 
 fonts.packages = with pkgs; [
    nerd-fonts.iosevka-term
    nerd-fonts.terminess-ttf
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];
 
  security.rtkit.enable = true;
  services.udev.packages = [ pkgs.gnome-settings-daemon ]; 
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    prime = {
      sync.enable = true; 
      #offload = {
        #enable = true;
        #enableOffloadCmd = true;
      #};
      nvidiaBusId= "PCI:01:00:0";
      intelBusId = "PCI:00:02:0";
    };
  };
  services.switcherooControl.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  
  users.users.noraxaxv = {
    initialPassword = "noraxaxv";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
  
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    lynx
    git
    vim 
    wget
    busybox
    tmux
    lshw
    mangohud
    protonup
    lutris
    bottles
    vscode.fhs
    steam-run
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        jdk8
        jdk17
        jdk21
     ];
    })
  ];
  
  environment.sessionVariables = { 
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d/";
    EDITOR = "hx";
  };
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.zsh.enable = true;
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

