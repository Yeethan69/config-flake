{ ... }:
{
  programs.gamemode.enable = true;
  boot.kernelParams = [
    "preempt=full"
  ];
}
