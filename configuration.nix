#i/sh Epqit this configuration file to dsomenameefine what should be installed onQ
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  neovim = import ./nvim.nix;
  tmux = import ./tmux.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot packages
  # if we want to change the kernel, we can run
  boot.kernelPackages = pkgs.linuxPackages_6_11;
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  # add Kernel Module
  #boot.extraModulePackages = [ config.boot.kernelPackages.uscvideo ];
  # auto load Kerne Module at startup
  #boot.kernelModules = [ "uscvideo" ];

  networking.hostName = "nixos-laptop"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # dns over vpn?
  services.resolved.enable = true;

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
  #services.libinput.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # idk doesnt work for the cam
  # refactor later
  nixpkgs.config.allowUnfree = true;
  #print driver is unfree

#  nixpkgs.config.allowUnfreePredicate = pkg:
#    builtins.elem (lib.getName pkg) [
#      "teams"
##      # Add additional package names here
##      "libfprint-2-tod1-goodix"
##      "ipu6-camera-bins"
##      "ipu6-camera-bins-unstable-2023-10-26-zstd"
#    ];

  # lets try to activate the fingerrpint
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };

    # Make the webcam work (needs Linux >= 6.6):
    # check with
    # nix-shell -p nix-info --run "nix-info -m"
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6ep";
  # this is not working for an kernel newer than 6.8

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true; # outdated
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
  #services.xserver.libinput.enable = true;
  services.libinput.enable = true;

  # try services for gpg and pinentry
  # TODO: check if really needed
  services.dbus.packages = [pkgs.gcr];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.developer = {
    isNormalUser = true;
    description = "N";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    packages = with pkgs; [
      brave
      firefox
      godot_4
      blender
      thunderbird
      git
      # rust
      cargo
      rustc
      gcc
      # lsp
      # - rust, nix
      rust-analyzer
      rustfmt
      nil
      # elm
      elmPackages.elm 
      elmPackages.elm-language-server
      elmPackages.elm-test
      elmPackages.elm-format
      # try to compile with fsharpc
      # and run with mono?
      mono
      # latex
      texliveFull
      # brother home printer
      brlaser
      # work related
      teams-for-linux
      #openvpn3
      openvpn
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
    wl-clipboard
    htop
    #am I done cding hmm ...
    # how do i run 
    # eval "$(zoxide init bash)" 
    # on startup?
    zoxide
    # openssl
    openssl_3_3
    # webcam?
    #libwebcam
    #linux-firmware
    # imge formats?
    # v4l-utils
    # do i need for webcam?
    gst_all_1.gstreamer
  ];

  #programs.zoxide.enable = true;
  # programs.bash.shellInit = ''
  # TEST="hello from nix"
  # eval "$(zoxide init bash)"
  # '';

  # enable z command from zoxide
  programs.bash.interactiveShellInit = ''
    eval "$(zoxide init bash)"
  '';
  # lets setup some custom aliases
  programs.bash.shellAliases = {
    # task workflow
    qq = "siqi list";
    qa = "siqi add";
    # Start a new session or attach to an existing session named ...
    tan = "tmux new-session -A -s";
    # attach to last session
    ta = "tmux a";
    tn = "tmux new";
    # ll style
    tt = "tmux ls";
    tls = "tmux ls";
    tlk = "tmux list-keys";

    gs = "git status";
    gst = "git status -sb";
    gl = "git log";
    gls = "git log --graph --oneline";
    gll = "git log --pretty=format:'%h%x09%an%x09%ad%x09%s'";
    glast = "git log -1 HEAD --stat";
    gc = "git commit -m";
    ga = "git add";
    # usage gdiff commit-hash1 commit-hash2 filename
    gdiff = "git difftool -t vimdiff -y";
    # search for string in commits
    gsearch = "git rev-list --all | xargs git grep -F";

    rebuild = "sudo nixos-rebuild switch";
  };

# some EOF without leading spaces does the trick
# could not get it to work in another fashion
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        ${neovim.neovimRC}
	lua << EOF
	${neovim.luaRC}
        ${neovim.luaCustomHelp}
        ${neovim.luaCustomTreesitterKeys}
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
	  # fidget-nvim 
	  # needed
	  (nvim-treesitter.withPlugins (
                    plugins: with plugins; [
                      nix
		      rust
                      python
		      c
                      cpp
                      c_sharp
                      gdscript
                      bash
		      lua
		      vim
		      vimdoc
                      json
                      yaml
                      helm
		      query
                      elm
                      roc
                      ]
	  )) 
          # try
          nvim-treesitter-textobjects
	];
	opt = [ ];
      };
    };
  };

  programs.tmux = {
    enable = true;
    # add to /etc/tmux.conf
    extraConfig = ''${tmux.RC}'';
  };


  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
#    pinentryFlavor = "gtk2";
    enableSSHSupport = true;
  };


# try to make webcam work with ovc
#service.uvcvideo.enable = true;
#services.uvcvideo.dynctrl.enable = true;
#  services.uvcvideo = {
#    dynctrl.enable = true;
#    packages = [ pkgs.stable.tiscamera ];
#  };
  

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

  # Let's enable nix flakes permanent
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
