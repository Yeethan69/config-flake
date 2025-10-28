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
        LD_AUDIT = "${inputs.sls-steam.packages.${pkgs.system}.sls-steam}/SLSsteam.so";
      };
    };
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    fontPackages = with pkgs; [
      noto-fonts-emoji
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
}
