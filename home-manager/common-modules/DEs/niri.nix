{
  inputs,
  pkgs,
  lib,
  config,
  vars,
  ...
}:
{

  imports = with inputs; [
    niri.homeModules.niri
    niri.homeModules.stylix
  ];

  config = if vars.DE.name != "niri" then {
    # Still override the niri version if not selected to enable compilation of kdl
    nixpkgs.overlays = [
      inputs.niri.overlays.niri
    ];
    programs.niri = {
      package = pkgs.niri-unstable;
    };
  } else lib.mkIf (vars.DE.name == "niri") {
    home.file.".de" = {
      text = ''
        export DE=niri-session
      '';
      executable = true;
    };

    # Satellite
    systemd.user.services.xwayland-satellite = {
      Unit = {
        Description = "XWayland Satellite - X Server";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
        Restart = "on-failure";
        RestartSec = "5s";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Waypaper
    systemd.user.timers.waypaper = {
      Unit = {
        Description = "Set a random wallpaper every minute";
      };
      Timer = {
        Persistent = true;
        OnCalendar = "*:0/1";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    systemd.user.services.waypaper = {
      Unit = {
        Description = "Set a random wallpaper with waypaper";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        KillMode = "process";
        Environment = [ "DISPLAY=:0" ];
        ExecStart = "${pkgs.waypaper}/bin/waypaper --random --monitor ${vars.display.name}";
      };
    };

    services.swww.enable = true;
    services.swww.package = inputs.swww.packages.${pkgs.system}.swww;

    # Mako
    services.mako = {
      enable = true;
      settings = {
        actions = true;
        anchor = "top-right";
        border-radius = 15;
        default-timeout = 5000;
        height = 100;
        width = 300;
        icons = true;
        ignore-timeout = false;
        layer = "top";
        margin = 10;
        markup = true;
      };
    };
    # Swayidle
    services.swayidle = {
      enable = true;
      systemdTarget = "graphical-session.target";
      events = [
        {
          event = "before-sleep";
          command = "swaylock -f";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "swaylock -f";
        }
        {
          timeout = 301;
          command = "niri msg action power-off-monitors";
        }
      ];
    };

    programs.swaylock.enable = true;

    gtk = {
      enable = true;
      iconTheme.name = "Nordzy";
      iconTheme.package = pkgs.nordzy-icon-theme;
    };

    xdg.portal = {
      enable = true;
      config = {
        common = {
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
        };
      };
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    programs.fuzzel.enable = true;

    nixpkgs.overlays = [
      inputs.niri.overlays.niri
    ];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;

      settings = {
        outputs.${vars.display.name} = {
          mode = {
            width = vars.display.resolution.width;
            height = vars.display.resolution.height;
            refresh = vars.display.refresh;
          };
          scale = vars.display.scale;
        };

        prefer-no-csd = true;
        environment = {
          DISPLAY = ":0";
          NIXOS_OZONE_WL = "1";
        };

        spawn-at-startup = [
          { command = [ "systemctl --user restart waybar.service" ]; }
          {
            command = [ "systemctl --user restart xwayland-satellite.service" ];
          }
          { command = [ "systemctl --user restart waypaper.timer" ]; }
        ];

        window-rules = [
          {
            geometry-corner-radius = {
              bottom-left = 15.0;
              bottom-right = 15.0;
              top-left = 15.0;
              top-right = 15.0;
            };
            clip-to-geometry = true;
          }
        ];

        layer-rules = [
          {
            matches = [ { namespace = "swww-daemon"; } ];
            place-within-backdrop = true;
          }
        ];

        layout = {
          background-color = "transparent";
        };

        overview = {
          workspace-shadow.enable = false;
        };

        binds =
          with config.lib.niri.actions;
          let
            sh = spawn "sh" "-c";
          in
          {
            "Mod+D".action = spawn "fuzzel";
            "Mod+T".action = spawn "${vars.terminal}";

            "Mod+Left".action = focus-column-left;
            "Mod+Down".action = focus-window-down;
            "Mod+Up".action = focus-window-up;
            "Mod+Right".action = focus-column-right;

            "Mod+Ctrl+Left".action = move-column-left;
            "Mod+Ctrl+Down".action = move-window-down;
            "Mod+Ctrl+Up".action = move-window-up;
            "Mod+Ctrl+Right".action = move-column-right;

            "Mod+Page_Down".action = focus-workspace-down;
            "Mod+Page_Up".action = focus-workspace-up;

            "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
            "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;

            "Mod+Shift+Page_Down".action = move-workspace-down;
            "Mod+Shift+Page_Up".action = move-workspace-up;

            "Mod+V".action = toggle-window-floating;
            "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

            "Mod+1".action = focus-workspace 1;
            "Mod+2".action = focus-workspace 2;
            "Mod+3".action = focus-workspace 3;
            "Mod+4".action = focus-workspace 4;
            "Mod+5".action = focus-workspace 5;
            "Mod+6".action = focus-workspace 6;
            "Mod+7".action = focus-workspace 7;
            "Mod+8".action = focus-workspace 8;
            "Mod+9".action = focus-workspace 9;

            "Mod+Comma".action = consume-or-expel-window-left;
            "Mod+Period".action = consume-or-expel-window-right;

            "Mod+Space".action = toggle-overview;

            "Mod+W".action = sh ''pkill -SIGUSR1 waybar'';
            "Mod+R".action = switch-preset-column-width;
            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+C".action = center-column;

            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Equal".action = set-column-width "+10%";

            "Print".action = screenshot;

            "Mod+Shift+Slash".action = show-hotkey-overlay;
            "Mod+Q".action = close-window;
            "Mod+Shift+E".action = quit;
          };
      };
    };
  };
}
