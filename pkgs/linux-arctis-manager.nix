{ lib, python3, fetchFromGitHub, qt6, ... }: 
    python3.pkgs.buildPythonApplication {
      pname = "linux-arctis-manager";
      version = "2.3.1";
      pyproject = true;

      src = fetchFromGitHub {
          owner = "elegos";
          repo = "Linux-Arctis-Manager";
          rev = "v2.3.1";
          sha256 = "sha256-eeh2cUOLuezPKI+QdaYMgthaBOv/ccSoBEFJ50LZ59c=";
      };

      # The upstream pyproject.toml pins uv_build >=0.10.9,<0.11.0, but
      # nixpkgs currently ships an older uv-build. The backend itself is
      # API-compatible for what this project needs, so we relax the pin
      # at build time rather than vendor a custom uv-build derivation.
      postPatch = ''
        substituteInPlace pyproject.toml \
          --replace-fail 'uv_build>=0.10.9,<0.11.0' \
                         'uv_build>=${python3.pkgs.uv-build.version}'
      '';

      build-system = [ python3.pkgs.uv-build ];

      dependencies = with python3.pkgs; [
        dbus-next
        pulsectl
        pyside6
        pyudev
        pyusb
        ruamel-yaml
      ];

      # Tests are not run during the build (they require live hardware).
      doCheck = false;

      nativeBuildInputs = [ qt6.wrapQtAppsHook ];
      buildInputs = [ qt6.qtbase ];

      postInstall = ''
        # 1. Generate udev rules using the freshly installed lam-cli.
        #    The rules are derived from the bundled device YAML configs,
        #    so we let the project itself generate them to stay in sync.
        #    `wrapPythonPrograms` has not run yet at this point, so we
        #    invoke the entry point through the interpreter and set
        #    PYTHONPATH manually to include all runtime dependencies.
        install -d "$out/lib/udev/rules.d"
        export PYTHONPATH="$out/${python3.sitePackages}:$PYTHONPATH"
        ${python3.interpreter} -m linux_arctis_manager.scripts.cli \
          udev write-rules \
          --rules-path "$out/lib/udev/rules.d/91-steelseries-arctis.rules" \
          --force

        # 2. Desktop entries. Patch them so they invoke the absolute
        #    path to lam-gui (no $PATH lookup needed).
        install -d "$out/share/applications"
        for desktop in ArctisManager.desktop ArctisManagerSystray.desktop; do
          src_file="$out/${python3.sitePackages}/linux_arctis_manager/desktop/$desktop"
          dst_file="$out/share/applications/$desktop"
          install -m644 "$src_file" "$dst_file"
          substituteInPlace "$dst_file" \
            --replace-quiet "exec lam-gui" "$out/bin/lam-gui"
        done

        # 3. Application icon.
        install -Dm644 \
          "$out/${python3.sitePackages}/linux_arctis_manager/gui/images/steelseries_logo.svg" \
          "$out/share/icons/hicolor/scalable/apps/arctis-manager.svg"

        # 4. Systemd user unit (referenced by the NixOS module, but also
        #    handy for non-NixOS users consuming this flake directly).
#         install -d "$out/lib/systemd/user"
#         cat > "$out/lib/systemd/user/arctis-manager.service" <<EOF
# [Unit]
# Description=Arctis Manager
# StartLimitInterval=1min
# StartLimitBurst=5
#
# [Service]
# Type=simple
# ExecStart=$out/bin/lam-daemon
# Restart=on-failure
# RestartSec=5
#
# [Install]
# WantedBy=graphical-session.target
# EOF
      '';

      meta = with lib; {
        description = "Open-source replacement for SteelSeries GG to manage Arctis headsets on Linux";
        homepage = "https://github.com/elegos/Linux-Arctis-Manager";
        license = licenses.gpl3Only;
        platforms = platforms.linux;
        mainProgram = "lam-gui";
      };
    }
