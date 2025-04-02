{ config, ...}: {
    sops = {
        #age.keyFile = "/home/user/.age-key.txt"; # must have no password!
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        # It's also possible to use a ssh key, but only when it has no password:
        #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
        #defaultSopsFile = ../secrets/git.sops.yaml;
    };
}
