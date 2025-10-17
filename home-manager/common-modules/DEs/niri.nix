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
  config =
    if vars.DE.name != "niri" then
      {
        # Still override the niri version if not selected to enable compilation of kdl
        nixpkgs.overlays = [
          inputs.niri.overlays.niri
        ];
        programs.niri = {
          package = pkgs.niri-unstable;
        };
      }
    else
      lib.mkIf (vars.DE.name == "niri") {
        home.file.".de" = {
          text = ''
            export DE=niri-session
          '';
          executable = true;
        };

        home.packages = with pkgs; [
          xfce.thunar.override
          {
            thunarPlugins = [ pkgs.xfce.thunar-archive-plugin ];
          }
          xarchiver
        ];

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

        # CopyQ
        systemd.user.services.copyq = {
          Unit = {
            Description = "CopyQ clipboard management daemon";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.copyq}/bin/copyq";
            Restart = "on-failure";
            RestartSec = "5s";
            Environment = "QT_QPA_PLATFORM=wayland";
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };

        # inhibridge
        systemd.user.services.inhibridge = {
          Unit = {
            Description = "Bridges freedesktop.org ScreenSaver inhibitions to systemd-inhibit";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.inhibridge}/bin/inhibridge";
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
            ExecStart =
              let
                waypaper = pkgs.waypaper.overrideAttrs (
                  final: prev: {
                    src = pkgs.fetchgit {
                      url = "https://github.com/anufrievroman/waypaper";
                      rev = "fbe2df22624f9c679589ad9759dbed53634c4379";
                      hash = "sha256-5Sl7s/YtBpLu7SCuomIU5kJ+L3EDgI8H5LDrgwesEG0=";
                    };
                  }
                );
              in
              "${waypaper}/bin/waypaper --folder ${config.home.homeDirectory}/wallpapers --random --monitor ${vars.display.name}";
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
            border-size = 4;
            default-timeout = 5000;
            height = 300;
            width = 600;
            icons = true;
            ignore-timeout = false;
            layer = "top";
            margin = 15;
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
              command = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --effect-pixelate 15 --clock -f";
            }
          ];
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --effect-pixelate 15 --clock -f";
            }
            {
              timeout = 301;
              command = "${pkgs.niri-unstable}/bin/niri msg action power-off-monitors";
            }
            {
              timeout = 600;
              command = "${pkgs.systemd}/bin/systemctl sleep";
            }
          ];
        };

        programs.swaylock.enable = true;
        programs.swaylock.package = pkgs.swaylock-effects;

        #Gui authentication
        systemd.user.services.polkit-gnome = {
          Unit = {
            Description = "GNOME PolicyKit Agent";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = "5s";
          };
          Install = {
            WantedBy = [ "graphical-session.target" ];
          };
        };

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

            clipboard = {
              disable-primary = true;
            };

            # input.mouse = {
            #   scroll-method = "on-button-down";
            #   scroll-button = 274;
            #   #  scroll-button-lock = true;
            # };

            prefer-no-csd = true;
            environment = {
              DISPLAY = ":0";
              NIXOS_OZONE_WL = "1";
              SDL_VIDEO_ALLOW_SCREENSAVER = "1";
            };

            spawn-at-startup = [
              { command = [ "systemctl --user restart waybar.service" ]; }
              {
                command = [ "systemctl --user restart xwayland-satellite.service" ];
              }
              { command = [ "systemctl --user restart waypaper.timer" ]; }
              { command = [ "systemctl --user restart copyq.service" ]; }
            ];

            window-rules = [
              {
                geometry-corner-radius = {
                  bottom-left = 10.0;
                  bottom-right = 10.0;
                  top-left = 10.0;
                  top-right = 10.0;
                };
                clip-to-geometry = true;
              }
              {
                # Copyq
                matches = [ { app-id = "com.github.hluk.copyq"; } ];
                open-floating = true;
                open-focused = true;
                default-floating-position = {
                  relative-to = "bottom";
                  y = 16;
                  x = 0;
                };
              }
              {
                # Firefox PiP
                matches = [ { title = "Picture-in-Picture"; } ];
                open-floating = true;
                open-focused = false;
                default-floating-position = {
                  relative-to = "bottom-right";
                  x = 16;
                  y = 16;
                };
              }
              {
                # Volume Control
                matches = [ { app-id = "org.pulseaudio.pavucontrol"; } ];
                open-floating = true;
                open-focused = true;
                min-width = 754;
                default-floating-position = {
                  relative-to = "top-right";
                  x = 270;
                  y = 16;
                };
              }
            ];

            layer-rules = [
              {
                matches = [
                  { namespace = "swww-daemon"; }
                  { namespace = "linux-wallpaperengine"; }
                ];
                place-within-backdrop = true;
              }
            ];

            layout = {
              border.width = 1;
              background-color = "transparent";
              preset-column-widths = [
                { proportion = 1. / 4.; }
                { proportion = 1. / 3.; }
                { proportion = 1. / 2.; }
                { proportion = 2. / 3.; }
              ];
              always-center-single-column = true;
            };

            overview = {
              workspace-shadow.enable = false;
            };

            binds = with config.lib.niri.actions; {
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
              "Mod+Ctrl+V".action = spawn-sh ''${pkgs.copyq}/bin/copyq toggle'';

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

              "Mod+W".action = spawn-sh ''pkill -SIGUSR1 waybar'';
              "Mod+R".action = switch-preset-column-width;
              "Mod+F".action = maximize-column;
              "Mod+Shift+F".action = fullscreen-window;
              "Mod+C".action = center-column;
              "Mod+Ctrl+C".action = center-visible-columns;

              "Mod+Minus".action = set-column-width "-10%";
              "Mod+Equal".action = set-column-width "+10%";

              "Print".action = screenshot;

              "Mod+Shift+Slash".action = show-hotkey-overlay;
              "Mod+Q".action = close-window;
              "Mod+Shift+E".action = quit;
              "XF86AudioRaiseVolume".action = spawn-sh ''${pkgs.pamixer}/bin/pamixer -i 1'';
              "XF86AudioLowerVolume".action = spawn-sh ''${pkgs.pamixer}/bin/pamixer -d 1'';
              "XF86AudioPlay".action = lib.mkIf (lib.elem "playerctl" vars.music) (
                spawn-sh ''${pkgs.playerctl}/bin/playerctl play-pause''
              );
              "XF86AudioNext".action = lib.mkIf (lib.elem "playerctl" vars.music) (
                spawn-sh ''${pkgs.playerctl}/bin/playerctl next''
              );
              "XF86AudioPrev".action = lib.mkIf (lib.elem "playerctl" vars.music) (
                spawn-sh ''${pkgs.playerctl}/bin/playerctl previous''
              );
            };
          };
        };
        # make thunar open folders without overriding mimeapps.list (xdg.mimeapps.enable = true)
        home.activation.set-thunar-for-folders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ $(${pkgs.xdg-utils}/bin/xdg-mime query default inode/directory) != thunar.desktop ]; then
            run ${pkgs.xdg-utils}/bin/xdg-mime default org.gnome.Nautilus.desktop inode/directory
          fi
        '';
      };
}
