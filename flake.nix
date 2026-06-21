{
  description = "Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake/main";
      #url = "git+file:/home/ethan/IdeaProjects/niri-flake";
      #url = "github:Yeethan69/niri-flake-merged-prs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prism = {
      url = "github:IogaMaster/prism?rev=3822346485a01fefb27f12d9f397c890b599ff7e";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swww.url = "github:LGFae/swww";
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nvf.url = "github:notashelf/nvf";
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix&rev=daa09988bbcae9df5c929951e985adecdb06a16e";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      hosts = {
        "hq" = {
          type = "Desktop";
          display = {
            resolution = {
              width = 5120;
              height = 1440;
            };
            refresh = 144.0;
            name = "DP-2";
            scale = 1.0;
          };
        };
        "pathfinder" = {
          type = "Laptop";
          display = {
            resolution = {
              width = 2880;
              height = 1800;
            };
            refresh = 120.0;
            name = "eDP-1";
            scale = 1.25;
          };
        };
      };
      userNames = [
        "ethan"
        "elsa"
      ];
      configPkgs = nixpkgs.legacyPackages.x86_64-linux;
      configPkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
    in
    {
      # 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        let
          systemConfig =
            hostname:
            nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit
                  inputs
                  outputs
                  hostname
                  userNames
                  ;
                vars = (import ./nixos/hosts/${hostname}/settings.nix) {
                  pkgs = configPkgs;
                  pkgs-unstable = configPkgs-unstable;
                };
              };
              modules = [ ./nixos/configuration.nix ];
            };
        in
        nixpkgs.lib.genAttrs (builtins.attrNames hosts) systemConfig;

      # A'home-manager --flake .#your-username@your-hostname'
      homeConfigurations =
        let

          # [
          #  { user = "ethan"; hostName = "hq";         hostSpecificConfig = hosts.hq; }
          #  { user = "ethan"; hostName = "pathfinder"; hostSpecificConfig = hosts.pathfinder; }
          #  { user = "elsa";  hostName = "hq";         hostSpecificConfig = hosts.hq; }
          # ...
          # ];
          homeConfigsToGenerate = nixpkgs.lib.concatMap (
            userName:
            nixpkgs.lib.map (hostKey: {
              inherit userName;
              hostName = hostKey;
              hostSpecificConfig = hosts.${hostKey};
            }) (builtins.attrNames hosts)
          ) userNames;

          homeConfig =
            {
              userName,
              hostName,
              hostSpecificConfig,
            }:
            home-manager.lib.homeManagerConfiguration {
              pkgs = configPkgs;
              extraSpecialArgs = {
                inherit
                  inputs
                  outputs
                  userName
                  hostName
                  ;
                pkgs-unstable = configPkgs-unstable;
                vars = (import ./home-manager/users/${userName}/settings.nix) { pkgs = configPkgs; } // {
                  inherit (hostSpecificConfig) type display;
                };
              };
              modules = [ ./home-manager/home.nix ];
            };

        in
        nixpkgs.lib.listToAttrs (
          nixpkgs.lib.map (config: {
            name = "${config.userName}@${config.hostName}";
            value = homeConfig config;
          }) homeConfigsToGenerate
        );
    };
}
