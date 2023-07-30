# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vim.nix
      ./virt-and-containers.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
  system.stateVersion = "23.05";

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.buc = {
    isNormalUser = true;
    description = "buc";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCj7x8LduqYvqWC7VA4KvnJOd7DNVZhPsU0h2rFHRUx186jFj340ywZWWoV8Zd2u6g3NapVel4YgD53eL67Ax4hngGEV0ioZ3JF2uYjuS+RzHTZ5w9F950EMdeZJAhnJxCIMrSj9nHLOJPaTMSOfhq6khtiyKvIg6jc+fSL2Rnxv2MFtWmqJAwwbdYYxDp1NFoqH5OTM7R8b1zg1Y687HmaQWHKDvnypbmyn5qeMQ6d5bM7tiolHck0gq33gr72FQs4rI+xt6WOIcVl1tbbmrrbQq7RiK+4hZimLKlRpdzLYoViXC9+AVzGIwtPU2t+jsVpsiHDgD9YlpU9M9JUKlhf buc@BUC-Laptop"
    ];
    packages = with pkgs; [];
  };
  
  nixpkgs.config.packageOverrides = pkgs: {
    unstable = import ( builtins.fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz ) {};
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };


  environment.systemPackages = with pkgs; [
    pkgs.neovim
  ];
  


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  networking.defaultGateway = "10.0.0.1";
  networking.nameservers = [ "10.0.0.16" ];
  #networking.interfaces.enp1s0.ipv4.addresses = [{
  #  address = "10.0.0.171";
  #  prefixLength = 24;
  #}];
  networking.bridges.br0.interfaces = ["enp1s0"];
  networking.interfaces.br0.ipv4.addresses = [{ 
    address = "10.0.0.171";
    prefixLength = 24;
  }];


  networking.firewall.enable = true;


  # === My Stuff ==========================================================================================================================================

  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [
      "logind"
      "systemd"
    ];
    disabledCollectors = [
      "textfile"
    ];
    openFirewall = true;
  };
  services.cockpit = {
    enable = true;
    openFirewall = true;
    package = pkgs.cockpit.overrideAttrs { version = "295"; };
  };
  # Packagekit is blocked by https://github.com/NixOS/nixpkgs/issues/177946
  # Date of this comment: 16.07.2023
  services.packagekit.enable = false;
}
