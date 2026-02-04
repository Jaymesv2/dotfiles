
{ pkgs, config, pkgs-unstable, ... }: {
  programs.cwc = let 
      wlroots_0_20 = pkgs-unstable.wlroots_0_19.overrideAttrs (finalAttrs: prevAttrs: {
        src = pkgs-unstable.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "wlroots";
          repo = "wlroots";
          rev = "82d5ffb09ed659dd4530dc2361f289e6fa6e0d11";
          hash = "sha256-FWeaT+ZxHH5tdfDjAEbNuatpGtQF3WqjR48yFsZly50=";
        };
      });

    cwc-unstable = pkgs-unstable.cwc.overrideAttrs (old: {
        buildInputs = builtins.map (pkg: if pkg == pkgs-unstable.wlroots_0_19 then wlroots_0_20 else pkg) old.buildInputs;
    });

    cwc-wrapped =  
        pkgs.writeShellScriptBin "cwc" ''
        ${pkgs.systemd}/bin/systemd-cat -t cwc ${cwc-unstable}/bin/cwc
    '';

    cwc = pkgs.symlinkJoin {
      name = "cwc";
      paths = [
        cwc-wrapped
        cwc-unstable
      ];
    };
  in {
    enable = true;
    package = cwc-unstable;
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      cwc = {
        binPath = "${config.programs.cwc.package}/bin/cwc";
        prettyName = "cwc";
        comment = "CWC Compositor";
        extraArgs = [];
      };
    };
  };
}
