# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./disk-config.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
   nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
   time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
   networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pozender = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" "sudo" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       tree
     ];
     hashedPassword = "$y$j9T$8G6FkTrQPMjvhvdb7tNYQ.$TTrwjKLcqgwuysGIw9CruFm/sw6xGtTEn7fjklj2no1";
     
     openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYFcLnKJYl2fzFrQhIXmECSSJBWdp/dXwjiI1XUfmrs pozender@MacBook-Air-de-florian.local"
    ];

   };
  
  users.users.root.openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJYFcLnKJYl2fzFrQhIXmECSSJBWdp/dXwjiI1XUfmrs pozender@MacBook-Air-de-florian.local"
    ];


  # programs.firefox.enable = true;
  virtualisation.docker.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   nixpkgs.config.allowUnfree = true;
   environment.systemPackages = with pkgs; [
     vim 
     exfat
     wget
     docker-compose
     nmap
     git
     neovim
     curl
     jellyfin
     compose2nix
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
   networking.firewall.enable = false;


   networking = {
   useDHCP = false;
   interfaces = {
     "enp3s0" = {
       ipv4.addresses = [{
	  address = "192.168.1.167";
	  prefixLength = 24;
          }];
        };

   };
   defaultGateway = "192.168.1.1";
   nameservers = [ "8.8.8.8" "8.8.4.4"];
  }; 
 
  ### Docker-compose strating ###
  systemd.services.dockers-services = {
    script = ''
      ${pkgs.docker-compose}/bin/docker-compose -f /etc/nixos/docker-containers/docker-compose.yml up -d
    '';
     wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" "docker.socket" ];
  };
  ### Docker-compose strating ###

  ## Mounting FS ##
  fileSystems."/home/shares/public/medias1" = {
    device = "/dev/disk/by-uuid/dab8db95-59d5-4e46-bea4-22eba9ea419f";
    fsType = "ext4";
    options = [ # If you don't have this options attribute, it'll default to "defaults" 
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount

    ];
  };
  ## Mounting FS ##

  ## Jellyfin Service ###
  services.jellyfin = {
    user = "jellyfin";
    enable = true;
    
  };
  users.groups.media.members = [ "pozender" "jellyfin" ];
   ### Jellyfin ###

 
 # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

