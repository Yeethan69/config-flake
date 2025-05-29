{
  lib,
  vars,
  pkgs,
  ...
}:
{
  config = lib.mkIf (vars.DE.waybar.enable == true) {
    # https://github.com/thnikk/fuzzel-scripts/blob/master/fuzzel-powermenu.sh
    programs.waybar = {
      style = ''
        * {
          border: none;
          border-radius: 15;
        }

        window#waybar, tooltip {
          background: alpha(@base00, 0.0);
          color: @base05;
        }

        .modules-right #clock {
          background-color: @base09;
          color: @base00;
        }

        .modules-left #workspaces button.focused,
        .modules-left #workspaces button.active {
          color: @base07;
        }

        #mpris {
          background-color: @base0B;
          color: @base00;
        }
      '';

      settings = {
        mainBar = {
          layer = "top";
          height = 32;
          spacing = 4;
          margin = "16px, 16px, 0px, 16px";
          modules-left = [
            "niri/workspaces"
            "mpris"
          ];
          modules-center = [
            "niri/window"
          ];
          modules-right = [
            "mpd"
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "power-profiles-daemon"
            "cpu"
            "memory"
            "temperature"
            "backlight"
            "battery"
            "battery#bat2"
            "clock"
            "tray"
            "custom/power"
          ];
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };
          tray = {
            spacing = 10;
          };
          clock = {
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
          };
          cpu = {
            format = "{usage}%  ";
            tooltip = false;
          };
          memory = {
            format = "{}%  ";
          };
          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = [
              ""
              ""
              ""
            ];
          };
          backlight = {
            format = "{percent}% {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };
          battery = lib.mkIf (vars.type == "laptop") {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-full = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          power-profiles-daemon = {
            format = "{icon}";
            tooltip-format = "Power profile: {profile}\nDriver: {driver}";
            tooltip = true;
            format-icons = {
              default = "";
              performance = "";
              balanced = "";
              power-saver = "";
            };
          };
          network = {
            format-wifi = "{essid} ({signalStrength}%)  ";
            format-ethernet = "{ipaddr}/{cidr}  ";
            tooltip-format = "{ifname} via {gwaddr}  ";
            format-linked = "{ifname} (No IP)  ";
            format-disconnected = "Disconnected ⚠ ";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
          pulseaudio = {
            tooltip = false;
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}%  ";
            format-source-muted = " ";
            format-icons = {
              headphone = " ";
              hands-free = " ";
              headset = " ";
              phone = " ";
              portable = " ";
              car = " ";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pgrep pavucontrol > /dev/null && pkill pavucontrol || pavucontrol &";
          };
          mpris = {
            dynamic_order = [
              "artist"
              "title"
              "position"
              "length"
            ];
            format = "{player_icon} ({status_icon}) {dynamic}";
            player-icons = {
              spotify = " ";
              firefox = " ";
            };
            status-icons = {
              paused = "";
              playing = "";
            };
            tooltip-format = "";
          };
          "custom/power" =
            let
              fuzzel-powerscript = pkgs.writeShellScriptBin "power" ''
                      SELECTION="$(printf "1 - Lock\n2 - Sleep\n3 - Log out\n4 - Reboot\n5 - Reboot to UEFI\n6 - Hard reboot\n7 - Shutdown" | fuzzel --dmenu -l 7 -p "Power Menu: ")"

                      case $SELECTION in
                	      *"Lock")
                					swaylock;;
                				*"Sleep")
                		      systemctl sleep;;
                		    *"Log out")
                	  			swaymsg exit;;
                	  		*"Reboot")
                	  			systemctl reboot;;
                	  		*"Reboot to UEFI")
                	  			systemctl reboot --firmware-setup;;
                	  		*"Hard reboot")
                	  			pkexec "echo b > /proc/sysrq-trigger";;
                	 			*"Shutdown")
                	  			systemctl poweroff;;
                      esac
              '';
            in
            {
              format = "⏻ ";
              tooltip = false;
              on-click = "${fuzzel-powerscript}/bin/power";
              escape = true;
            };
        };
      };
    };
    stylix.targets.waybar.enableCenterBackColors = true;
    stylix.targets.waybar.enableLeftBackColors = true;
    stylix.targets.waybar.enableRightBackColors = true;
  };
}
