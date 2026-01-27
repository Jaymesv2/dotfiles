{
  boot = {
    kernelParams = [
        "resume_offset=533760"
    ];
    resumeDevice = "/dev/disk/by-label/nixos";
  };

  # Hibernate on power button pressed
  services.logind.settings.Login.LidSwitch = "suspend-then-hibernate";
  services.logind.settings.Login.PowerKey = "hibernate";
  services.logind.settings.Login.PowerKeyLongPress = "poweroff";

  # Suspend first
  boot.kernelParams = ["mem_sleep_default=deep"];

  # Define time delay for hibernation
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=2h
    HibernateOnACPower=no
    SuspendState=mem
  '';
}
