{ pkgs, lib, ... }: {
  programs.ssh = {
    enable = true;
    # addKeysToAgent = "yes";
    matchBlocks = {
      "*".extraOptions = {
        AddKeysToAgent = "yes";
      };
      "10.0.0.246".user = "trent";
      "10.0.0.1".extraOptions = {
	      PubkeyAcceptedAlgorithms = "+ssh-rsa";
    	    HostkeyAlgorithms = "+ssh-rsa";
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
