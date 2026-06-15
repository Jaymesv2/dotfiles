{ pkgs, lib, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        addKeysToAgent = "yes";
        # default config
        ForwardAgent = false; 
        Compression = false; 
        ServerAliveInterval = 0; 
        ServerAliveCountMax = 3; 
        HashKnownHosts = false; 
        UserKnownHostsFile = "~/.ssh/known_hosts"; 
        ControlMaster = "no"; 
        ControlPath = "~/.ssh/master-%r@%n:%p"; 
        ControlPersist = "no"; 
      };
      "10.0.0.246".user = "trent";

      "10.0.0.1" = {
        PubkeyAcceptedAlgorithms = "+ssh-rsa";
        HostkeyAlgorithms = "+ssh-rsa";
        identityFile = "~/.ssh/id_rsa";
      };

      "ctf-vm*.utdallas.edu" = {
        User = "tlt210003";
        SetEnv = {
          TERM = "xterm";
        };
      };
      "cs*.utdallas.edu" = {
        User = "tlt210003";
        SetEnv = {
          TERM = "xterm";
        };
      };
      "borg" = {
        Match = "user backup host \"10.0.10.20\"";
        IdentityFile = "~/.ssh/borg_ed25519";
        ServerAliveCountMax = 30;
        ServerAliveInterval = 10;
        # nix doesnt recognize this :(
        #passwordAuthentication = "no";
      };
    };
  };
  services.ssh-agent.enable = true;
}
