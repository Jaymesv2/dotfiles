{ lib, buildNpmPackage, fetchFromGitHub, ... }: 
    buildNpmPackage (finalAttrs: {
      pname = "ipfs-car";
      version = "3.1.0";

      src = fetchFromGitHub {
        owner = "storacha";
        repo = "ipfs-car";
        tag = "v${finalAttrs.version}";
        hash = "sha256-DbjyyM2P5K+wV5khbySwfAVzjdzKJ4/6UwHsxf/6bqs=";
      };

      npmDepsHash = "sha256-vjDb5jgA3uFqSxZOD98X7I6DEs9g4NR4alCBEGUXEx8=";

      # The prepack script runs the build script, which we'd rather do in the build phase.
      # npmPackFlags = [ "--ignore-scripts" ];
      dontNpmBuild = true;
      # NODE_OPTIONS = "--openssl-legacy-provider";

      meta = {
        description = "";
        # Modern web UI for various torrent clients with a Node.js backend and React frontend";
        homepage = "";
        # https://flood.js.org";
        license = [lib.licenses.mit lib.licenses.asl20];
        maintainers = [];
      };
    })
