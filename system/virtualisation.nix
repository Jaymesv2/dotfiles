{ lib, pkgs, options, config, ... }: {

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  virtualisation = {
    # docker = {
    #   enable = true;
    #   enableOnBoot = false;
    # };
    podman = {
      enable = true;
      autoPrune.enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;
      
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.groups.podman = {
    name = "podman";
  };

  users.users.trent.extraGroups = ["podman"];

  # for now podman on root won't persist

  # environment.persistence."/persistent" = {
  #   directories = [
  #     { directory = "/var/lib/containers"; user = "root"; group = "root"; mode="u=rwx,g=x,o="; }
  #   ];
  # };
}
