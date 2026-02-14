{ lib, stdenv, electron_39, nodejs_24, makeDesktopItem, copyDesktopItems, fetchFromGitHub, breakpointHook, ipfs-car, fetchurl, npmHooks, fetchNpmDeps, importNpmLock, ... }: let
    electron = electron_39;
    nodejs = nodejs_24;
    contentAddr = "bafybeidsjptidvb6wf6benznq2pxgnt5iyksgtecpmjoimlmswhtx2u5ua";
    cont = fetchurl {
        url = "https://trustless-gateway.link/ipfs/${contentAddr}?format=car";
        hash = "sha256-xeTHFQnPcNXfHzojz5uBeo2dpVMmBzZoSE6EK8H7/Vo=";
    };
    # why is everything written in js awful to package???
in stdenv.mkDerivation (finalAttrs: rec {
    pname = "ipfs-desktop";
    version = "v0.47.0";
    src = fetchFromGitHub {
        owner = "ipfs";
        repo = "ipfs-desktop";
        tag = finalAttrs.version;
        hash = "sha256-YPdkGxG3CZhfgTtG6okVCHcO9O/qgcA20L6qFCMi+4Y=";
    };
    preUnpack = ''
        export HOME="$TMPDIR"
        export npm_config_cache="$TMPDIR/npm-cache"
        export npm_config_tmp="$TMPDIR"
    '';

    # Currently this doesn't work
    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-DGf8ykhpF2eEOP6ltYa8r0weEIVAHT9t0u5mx1Ua+Vg=";
      npmRoot = ".";
      # npmFlags = [
      #   "--cache=$TMPDIR/npm-cache"
      #   "--tmp=$TMPDIR"
      # ];
    };
    

    nativeBuildInputs = [ 
        electron nodejs 
        # importNpmLock.npmConfigHook

        npmHooks.npmConfigHook 
        # npmHooks.npmInstallHook 
        # npmHooks.npmBuildHook
        ] ++ [ breakpointHook ];

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

    postUnpack  = ''
        ${ipfs-car}/bin/ipfs-car unpack ${cont} --output=source/assets/webui/
    '';
    buildPhase = ''

         runHook preBuild
        # _warn_if_electron_outdated
        # export SYSTEM_ELECTRON_VERSION=$(< "/usr/lib/$${_electron_pkg}/version")

        # ${nodejs}/bin/npm ci --no-audit --no-fund
        # ${nodejs}/bin/npm run build:webui:down
        ${nodejs}/bin/npm run build:webui:minimize
        # rm -rf assets/webui/static/js/*.map && rm -rf assets/webui/static/css/*.map
        # ${nodejs}/bin/npm exec -- electron-builder --linux --dir --publish never "$${_builder_options[@]}"

        echo "building"

        # npm install \
        #     ./node_modules/.bin/electron-builder \
        #       --linux \
        #       --publish never \
        #       --dir \
        #       -c.electronDist=${if stdenv.hostPlatform.isDarwin then "." else electron.dist} \
        #       -c.electronVersion=${electron.version}

        echo "built"
        runHook postInstall
    '';




    # installPhase = ''
      # runHook preInstall
      #
      # find $out -type f \( \
      #   -name \*.lastUpdated \
      #   -o -name resolver-status.properties \
      #   -o -name _remote.repositories \) \
      #   -delete
      #
      # runHook postInstall
    # '';
    installPhase = ''
        # _electron_env

        # depends=("$_electron_pkg")

        # mkdir -pm755 "$pkgdir/usr/lib/$pkgname"
        mkdir -pm755 "$out/usr/lib/${pname}"

        cp -a "$_pkgsrc/dist/linux-unpacked/resources"/* -t "$pkgdir/usr/lib/$pkgname/"
        rm -f \
            "$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/kubo/tsconfig.json"
        rm -f \
            "$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/kubo/LICENSE" \
            "$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/kubo/kubo/README.md" \
            "$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/kubo/kubo/build-log" \
            "$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/kubo/kubo/install.sh" \
            "$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/kubo/kubo/LICENSE" \
            "$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/kubo/kubo/LICENSE-APACHE" \
            "$pkgdir/usr/lib/$pkgname/app.asar.unpacked/node_modules/kubo/kubo/LICENSE-MIT"

        install -Dm644 "$_pkgsrc/assets/webui/ipfs-logo-512-ice.png" "$pkgdir/usr/share/pixmaps/$pkgname.png"
        install -Dm644 "$_pkgsrc/LICENSE" -t "$pkgdir/usr/share/licenses/$pkgname"

        install -Dm755 "$srcdir/ipfs-desktop-startup.sh" "$pkgdir/usr/bin/$pkgname"
        install -Dm644 "$srcdir/ipfs-desktop.desktop" "$pkgdir/usr/share/applications/$pkgname.desktop"

        chmod -R u+rwX,go+rX,go-w "$pkgdir/"
    '';
    desktopItems =  [
        (makeDesktopItem {
          type = "Application"; # idk if this will work
          name = "IPFS Desktop";
          desktopName = "IPFS Desktop";
          exec = "ipfs-desktop %u";
          terminal = false;
          startupNotify = true;
          icon = "ipfs-desktop";
          startupWMClass = "IPFS Desktop";
          comment = " Desktop client for the InterPlanetary File System";
          mimeTypes = [ "x-scheme-handler/ipfs" "x-scheme-handler/ipns" ];
          categories = [ "Network" "FileTransfer" "P2P" ];
        })
    ];
    meta = {
      description = "An unobtrusive and user-friendly desktop application for IPFS on Windows, Mac and Linux.";
      homepage = "https://github.com/ipfs/ipfs-desktop";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ ];
      mainProgram = "ipfs-desktop";
      platforms = electron.meta.platforms;
    };
})

