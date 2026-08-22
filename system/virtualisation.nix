{ lib, pkgs, options, config, ... }: {
  imports = [ ./vmconf.nix ];
  programs.virt-manager.enable = true;

  virtualisation.containers.enable = true;

  virtualisation = {
    libvirtd = {
        enable = true;
        qemu = {
            package = pkgs.qemu_kvm;
            swtpm.enable = true;
        };
    };
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

  environment.systemPackages = [ pkgs.virt-manager ];
  users.users.trent.extraGroups = [ config.users.groups.podman.name "libvirtd" "kvm" ];
}
