{
  pkgs,
  lib,
  vars,
  ...
}:
{
  config = lib.mkIf (vars.DE.name == "gnome") {
    home.file.".de" = {
      text = ''
        export XDG_SESSION_TYPE=wayland
        export DE="dbus-run-session gnome-session"
      '';
      executable = true;
    };
    
    # mostly from https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/x11/desktop-managers/gnome.nix
    
    home.packages = with pkgs; [
      gnome-session.sessions
      gsettings-desktop-schemas
      gnome-shell
      gnome-tweaks

      adwaita-icon-theme
      gnome-backgrounds
      gnome-bluetooth
      gnome-color-manager
      gnome-control-center
      glib
      gnome-menus
      gtk3.out
      xdg-user-dirs
      xdg-user-dirs-gtk

      decibels
      gnome-text-editor
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-console
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-system-monitor
      gnome-weather
      loupe
      nautilus
      gnome-connections
      snapshot
      totem

      sound-theme-freedesktop

      dleyna
      power-profiles-daemon
      at-spi2-core
      evolution
      gnome-keyring
      gnome-online-accounts
      localsearch
      tinysparql
      mutter
      gnome-browser-connector
      gnome-settings-daemon
      
      file-roller
      evince
      seahorse
      sushi
    ];

    home.sessionVariables = {
      NO_AT_BRIDGE = "1";
      GTK_A11Y = "none";
      GIO_EXTRA_MODULES = "${pkgs.gnome.gvfs}/lib/gio/modules";
    };
    
    services.polkit-gnome.enable = true;

    programs.firefox.nativeMessagingHosts = lib.mkIf (vars.browser == "firefox") [
      pkgs.gnome-browser-connector
    ];
    
    
    xdg = let
      # fix stylix not finding gnome-extensions
      activator = pkgs.writeShellApplication {
        name = "stylix-activator";
        text = ''
          EXTENSION_ID='user-theme@gnome-shell-extensions.gcampax.github.com'
          case "$1" in
            reload)
              ${pkgs.gnome-shell}/bin/gnome-extensions disable "$EXTENSION_ID"
              ${pkgs.gnome-shell}/bin/gnome-extensions enable "$EXTENSION_ID"
              ;;
            enable)
              ${pkgs.gnome-shell}/bin/gnome-extensions enable "$EXTENSION_ID"
              ;;
          esac
        '';
      };
    in {
      dataFile."themes/Stylix/gnome-shell/gnome-shell.css".onChange = lib.mkForce ''
        ${activator}/bin/stylix-activator reload
      '';
      
      configFile."autostart/stylix-activate-gnome.desktop" = {
        text = lib.mkForce ''
          [Desktop Entry]
          Type=Application
          Exec=${activator}/bin/stylix-activator enable
          Name=Stylix: enable User Themes extension for GNOME Shell (Fixed)
        '';
      };
      
      portal.enable = true;
      portal.extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      portal.configPackages = [ pkgs.gnome-session ];
    };
    
    # make nautilus open folders without overriding mimeapps.list (xdg.mimeapps.enable = true)
    home.activation.set-nautilus-for-folders = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ $(${pkgs.xdg-utils}/bin/xdg-mime query default inode/directory) != org.gnome.Nautilus.desktop ]; then
        run ${pkgs.xdg-utils}/bin/xdg-mime default org.gnome.Nautilus.desktop inode/directory
      fi
    '';
  };
}
