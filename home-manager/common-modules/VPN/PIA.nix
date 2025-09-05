{
  lib,
  vars,
  pkgs,
  config,
  ...
}:
let
  source = pkgs.fetchFromGitHub {
    owner = "pia-foss";
    repo = "manual-connections";
    rev = "e956c57849a38f912e654e0357f5ae456dfd1742";
    sha256 = "sha256-otDaC45eeDbu0HCoseVOU1oxRlj6A9ChTWTSEUNtuaI=";
  };

  start-script = pkgs.writeScriptBin "startpia" ''
    #!${pkgs.stdenv.shell}
    cd ${source}

    export VPN_PROTOCOL=wireguard
    export DISABLE_IPV6=no
    export DIP_TOKEN=no
    export AUTOCONNECT=false
    export PIA_PF=true
    export PIA_DNS=true
    export PREFERRED_REGION=nl_netherlands-so

    # ~/Documents/PIA/creds.env gets exported if exists, includes PIA_USER and PIA_PASS
    source ${config.home.homeDirectory}/Documents/PIA/creds.env

    rm -f /tmp/pia-run.log
    . ./run_setup.sh | tee --append /tmp/pia-run.log
  '';

  stop-script = pkgs.writeScriptBin "stoppia" ''
    #!${pkgs.stdenv.shell}
    killall -g startpia
    wg-quick down pia
    rm -f /tmp/pia-run.log
  '';
in
{
  config = lib.mkIf (vars.VPN == "PIA") {
    home.packages = [
      pkgs.jq
      pkgs.wireguard-tools
      start-script
      stop-script
    ];
  };
}
