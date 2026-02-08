{ lib, pkgs, options, config, ... }: {
  xdg = {
    # Maybe this would be useful at some point
    # autostart = {
    #   enable = true;
    #   entries = [
    #     
    #   ];
    # };
    #enable = true;
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # config.common.default = "*";
      config = {
        common = {
          default = [
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "nemo"
          ];
          "org.freedesktop.impl.portal.Secret" = [
            "gnome-keyring"
          ];
        };
        x-gnome = {
          default = [
            "gtk"
          ];
        };
      };
    };

    terminal-exec.enable = true;

    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let 
        document_viewer = "org.pwmt.zathura-pdf-mupdf.desktop;";
        image_viewer = "sxiv.desktop";
        video_player = "vlc.desktop";
        archive_viewer = "org.gnome.FileRoller.desktop";
    in {
      # documents
        "application/pdf" = document_viewer;
        "application/vnd.amazon.ebook" = document_viewer;
        "application/epub+zip" = document_viewer;
        #"text/html" = "firefox.desktop";


      # images
        "image/jpeg" = image_viewer;
        "image/webp" = image_viewer;
        "image/png" = image_viewer;
        "image/gif" = image_viewer;

        "image/apng" = image_viewer;
        "image/avif" = image_viewer;
        "image/vnd.microsoft.icon" = image_viewer;
        
      # audio

      # video
        "video/mp4" = video_player;
        "video/x-msvideo" = video_player; # .avi

      # archives
        "application/x-bzip" = archive_viewer; # .bz
        "application/x-bzip2" = archive_viewer; # .bz2
        "application/gzip" = archive_viewer;
        "application/x-gzip" = archive_viewer;
        
      # misc
        #"application/octet-stream" = "";
        #"text/calendar" = "";
      };
      #defaultApplications = {
      #  "word"
      #};
    };
    userDirs = {
      enable = true;
      createDirectories = true;

      extraConfig = {
        XDG_MISC_DIR = "${config.home.homeDirectory}/Misc";
      };
    };
    #  I think I need to add these to XDG_DATA_DIRS or PATH
    # '/var/lib/flatpak/exports/share'
    # '/home/trent/.local/share/flatpak/exports/share'


    # xdg.configFile = {
    #     "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    #     "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    #     "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    # };
  };
}
