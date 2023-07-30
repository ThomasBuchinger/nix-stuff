# nix-stuff

Nix configuration files for a basic server with podman containers and libvirt on NixOS.

Stuff that didn't work:
* Helf the funtions in Cockpit do not work
  * Metrics recording via performance-copilot
  * Package updates
  * No Storage information
  * cockpit-machines and cockpit-podman have only janky and abandoned (?) packages available
* Libvirt has no way to define VMs declaratively
* Some modules fallback to "give us the config file as text", which negates much of the usefulness
