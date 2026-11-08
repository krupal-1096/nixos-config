{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  # Binary cache
  nix.settings = {
    extra-substituters = [
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Niri
  programs.niri.enable = true;

  # Noctalia
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  # === Display Manager / Greeter ===
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  # Disable leftover GNOME services
  services.gnome.core-apps.enable = false;
  services.gnome.core-shell.enable = false;
  services.gnome.core-os-services.enable = false;
  services.gnome.games.enable = false;
  services.gnome.core-developer-tools.enable = false;

  # Enable Noctalia greeter only sd
  services.displayManager.noctalia-greeter.enable = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  # PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.krupal = {
    isNormalUser = true;
    description = "krupal";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    ghostty
    superfile
    mpv
    mpvScripts.uosc
    heroic
    steam
    git
    # Editor
    xed-editor

    # Nix development
    nil
    nixfmt

    # Other formatters
    ruff
    shfmt
    
    # dev tools
    python3
	
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.firefox.enable = true;
  
  services.displayManager.noctalia-greeter.passwordless-sync-users = [
  	"krupal"
  ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
