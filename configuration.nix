{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  # ======================
  # Nix settings (optimized for 16GB RAM & binary caches)
  # ======================
  nix = {
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ1ndhhRE0Gly5lEwQ="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];

      # builders-use-substitutes = true;
      max-jobs = 2;             # Safely limited to 4 to prevent OOM errors on 16GB RAM
      cores = 2;                # Use all available CPU cores per job when building
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # ======================
  # Hardware & Power Management
  # ======================
  hardware.cpu.amd.updateMicrocode = true;
  services.power-profiles-daemon.enable = true;

  # ======================
  # Desktop / Shell
  # ======================
  programs.niri.enable = true;

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;

    settings = {
        cursor = {
            theme = "Bibata-Modern-Ice";
            size = 24;
            path = pkgs.bibata-cursors;
        };

        keyboard = {
            layout = "us";
        };
    };
};
  services.displayManager.noctalia-greeter.passwordless-sync-users = [ "krupal" ];

  # ======================
  # Boot
  # ======================
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # ======================
  # Networking & Locale
  # ======================
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

  # ======================
  # Audio
  # ======================
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ======================
  # Users
  # ======================
  users.users.krupal = {
    isNormalUser = true;
    description = "krupal";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # ======================
  # Packages
  # ======================
  environment.systemPackages = with pkgs; [
    ghostty
    mpv
    mpvScripts.uosc
    heroic
    git
    kdePackages.dolphin
    kdePackages.kio
    kdePackages.kio-extras
    kdePackages.kio-fuse
    kdePackages.qtsvg
    xed-editor

    # Nix development
    nil
    nixfmt

    # Other formatters
    ruff
    shfmt

    # dev tools
    python3

    # compatibility
    xwayland-satellite

    # Android MTP
    libmtp

    # icons
    bibata-cursors

  ];

  programs.steam = {
  enable = true;
};

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.firefox.enable = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

xdg.portal = {
  extraPortals = [
    pkgs.kdePackages.xdg-desktop-portal-kde
  ];

  config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
  };
};


# Default application for directories
xdg.mime.defaultApplications = {
  "inode/directory" = "org.kde.dolphin.desktop";
};
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";
}
