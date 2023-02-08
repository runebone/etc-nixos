# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Modified by me
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          vim-nix
          vim-surround
          vim-commentary
          vim-airline
          vim-css-color
          srcery-vim
        ];
      };

      customRC = ''
        set encoding=utf-8
        set nohlsearch
        set clipboard+=unnamedplus
        set bg=dark

        set tabstop=4
        set shiftwidth=4
        set expandtab

        set autochdir

        set t_Co=256
        colorscheme srcery

        set number relativenumber
        set cul
        set cuc
        set colorcolumn=80

        inoremap {<CR> {<CR>}<C-o>O
        inoremap [<CR> [<CR>]<C-o>O
        inoremap (<CR> (<CR>)<C-o>O
      '';
    };
  };

  programs.zsh = {
    enable = true;

    ohMyZsh = {
      enable = true;
      # theme = "darkblood";
      theme = "half-life";
    };
  };

  environment.variables = {
    EDITOR = "nvim";
  };
  environment.shells = with pkgs; [ zsh ];
  
  # Configure fonts
  fonts = let
    m = [ "Mononoki" ];
    i = [ "Iosevka" ];
    r = [ "Roboto" ];
  in {
    fonts = with pkgs; [
      mononoki
      iosevka
      roboto
      nerdfonts
    ];
    fontconfig.defaultFonts = {
      monospace = m;
      sansSerif = r;
      serif = r;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    layout = "us,ru";
    xkbOptions = "grp:caps_toggle";

    displayManager.defaultSession = "none+bspwm";
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "human";

    windowManager.bspwm.enable = true;
  };
  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape"; # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.human = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" ]; # Enable ‘sudo’ for the user.

    packages = with pkgs; [
      home-manager
    ];

    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    wget
    xclip
    neovim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

