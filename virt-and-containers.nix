# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  users.users.root.extraGroups = [ "libvirtd" "docker" "podman"];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.buc.extraGroups = [ "libvirtd" "docker" "podman"];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  environment.systemPackages = with pkgs; [
    pkgs.virt-manager
    ( pkgs.nur.repos.fedx.cockpit-podman.overrideAttrs { version = "74"; } )
    pkgs.nur.repos.dukzcry.cockpit-machines
    pkgs.nur.repos.dukzcry.libvirt-dbus
    pkgs.python310Packages.libvirt
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers = {
    container-name = {
      image = "nginx";
      autoStart = true;
    };
  };

  virtualisation.libvirtd.enable = true;

  # There is no modue to declare VMs
}
