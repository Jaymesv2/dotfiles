{ lib, dpkg, fetchurl, stdenv, webkitgtk_4_1, autoPatchelfHook, gtk3, libappindicator-gtk3, libappindicator, libayatana-appindicator, makeWrapper, ... }:
stdenv.mkDerivation rec {
  pname = "wifiman-desktop";
  version = "0.0.1";
  src = fetchurl {
    url = "https://desktop.wifiman.com/wifiman-desktop-1.2.8-amd64.deb";
    hash = "sha256-R+MbwxfnBV9VcYWeM1NM08LX1Mz9+fy4r6uZILydlks=";
  };
  nativeBuildInputs = [ 
    dpkg 
    autoPatchelfHook 
    makeWrapper
    webkitgtk_4_1 
    gtk3 
    libappindicator
    libappindicator-gtk3
  ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    # install -m755 -D studio-link-standalone-v$ {version} $out/bin/studio-link
    cp -r usr/* $out
    runHook postInstall
  '';
  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        libayatana-appindicator  # or whatever the correct attr is
      ]}
  '';
}
