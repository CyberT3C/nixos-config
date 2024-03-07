# Epqit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  vars = import ./vars.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-laptop"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false; 
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # try services for gpg and pinentry
  # TODO: check if really needed
  services.dbus.packages = [pkgs.gcr];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.developer = {
    isNormalUser = true;
    description = "N";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      brave
      firefox
      godot_4
      blender
      thunderbird
      git
      git-credential-manager
      tmux
      # rust
      cargo
      rustc
      gcc
      # lsp
      # - rust, nix
      rust-analyzer
      nil
    ];
  };

  # For some reason git uses ssh-askpass in a not intended way
  # so it will screw up your cli ssh (user, pw) experience
  # this workaround gets the job done
  environment.variables = {
    GIT_ASKPASS="";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl

  ];

# some EOF without leading spaces does the trick
# could not get it to work in another fashion
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        ${vars.neovimRC}
	lua << EOF
	${vars.luaRC}
        ${vars.luaCustomHelp}
EOF
	'';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ 
	  nvim-lspconfig
	  # autocompletion
	  nvim-cmp
	  cmp-buffer
	  cmp-path
	  cmp-nvim-lsp
	  # style
	  tokyonight-nvim
	  # try some fun
	  fidget-nvim 
	  # needed
	  (nvim-treesitter.withPlugins (
                    plugins: with plugins; [
                      nix
		      rust
                      python
		      c
		      lua
		      vim
		      vimdoc
                      json
		      query
                      ]
	  )) 
	];
	opt = [ ];
      };
    };
  };


services.pcscd.enable = true;
programs.gnupg.agent = {
  enable = true;
  pinentryFlavor = "gtk2";
  enableSSHSupport = true;
};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
