{ pkgs, inputs, ... }:
{
  programs.gamemode.enable = true;
  boot.kernelParams = [
    "preempt=full"
  ];
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        LD_AUDIT = "${inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam}/SLSsteam.so";
      };
    };
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    fontPackages = with pkgs; [
      noto-fonts-color-emoji
      source-han-sans
    ];
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamescope.enable = true;
  environment.systemPackages = with pkgs; [
    mangohud
    mangojuice
    protonup-qt
  ];
  environment.etc = {
    # https://github.com/ValveSoftware/gamescope/issues/1626#issuecomment-2636817984
    "gamescope/scripts/disable_explicit_sync.lua" = {
      text = ''
        function info(text)
            gamescope.log(gamescope.log_priority.info, text)
        end

        info("Disabling explicit sync: " .. tostring(gamescope.convars.drm_debug_disable_explicit_sync.value) .. " -> " .. tostring(true))
        gamescope.convars.drm_debug_disable_explicit_sync.value = true
      '';
    };
  };
}
