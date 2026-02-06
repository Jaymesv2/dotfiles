{ pkgs, lib, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        # default config
        forwardAgent = false; 
        compression = false; 
        serverAliveInterval = 0; 
        serverAliveCountMax = 3; 
        hashKnownHosts = false; 
        userKnownHostsFile = "~/.ssh/known_hosts"; 
        controlMaster = "no"; 
        controlPath = "~/.ssh/master-%r@%n:%p"; 
        controlPersist = "no"; 

      };
      "10.0.0.246".user = "trent";
      "10.0.0.1".extraOptions = {
        PubkeyAcceptedAlgorithms = "+ssh-rsa";
        HostkeyAlgorithms = "+ssh-rsa";
        identityFile = "~/.ssh/id_rsa";
      };
      "ctf-vm*.utdallas.edu" = {
        user = "tlt210003";
        setEnv = {
          TERM = "xterm";
        };
      };
      "cs*.utdallas.edu" = {
        user = "tlt210003";
        setEnv = {
          TERM = "xterm";
        };
      };
      "borg" = {
        match = "user backup host \"10.0.10.20\"";
        identityFile = "~/.ssh/borg_ed25519";
        serverAliveCountMax = 30;
        serverAliveInterval = 10;
        # nix doesnt recognize this :(
        #passwordAuthentication = "no";
      };
    };
  };
  services.ssh-agent.enable = true;
}
