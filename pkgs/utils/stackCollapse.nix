{ writeTextFile, ...}: writeTextFile {
      name = "stack-collapse.py";
      destination = "/bin/stack-collapse.py";
      text = builtins.readFile (builtins.fetchurl
        {
          url = "https://raw.githubusercontent.com/NixOS/nix/master/contrib/stack-collapse.py";
          sha256 = "sha256:0mi9cf3nx7xjxcrvll1hlkhmxiikjn0w95akvwxs50q270pafbjw";
        });
      executable = true;
    }
