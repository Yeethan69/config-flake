{ lib, vars, ... }:
{
  config = lib.mkIf (vars.discord == "vesktop") {
    stylix.targets.vesktop.enable = false;
    programs.vesktop.vencord.settings = {
      plugins = {
        AlwaysAnimate.enabled = true;
        ClearURLs.enabled = true;
        Decor = {
          enabled = true;
          agreedToGuidelines = true;
        };
        FakeNitro = {
          enabled = true;
          enableStickerBypass = true;
          enableStreamQualityBypass = true;
          enableEmojiBypass = true;
          transformEmojis = true;
          transformStickers = true;
        };
        FakeProfileThemes = {
          enabled = true;
          nitroFirst = true;
        };
        FixSpotifyEmbeds = {
          enabled = true;
          volume = 10;
        };
        ImageZoom = {
          enabled = true;
          saveZoomValues = true;
          invertScroll = true;
          nearestNeighbour = false;
          square = false;
          zoom = 2;
          size = 100;
          zoomSpeed = 0.5;
        };
        # LastFMRichPresence.enabled = true;
        MessageLogger = {
          enabled = true;
          ignoreSelf = true;
          collapseDeleted = true;
          deleteStyle = "text";
          ignoreBots = false;
          ignoreUsers = "";
          ignoreChannels = "";
          ignoreGuilds = "";
          logEdits = true;
          logDeletes = true;
          inlineEdits = true;
        };
        OpenInApp = {
          enabled = true;
          spotify = true;
          steam = true;
          epic = true;
          tidal = true;
          itunes = true;
        };
        PictureInPicture = {
          enabled = true;
          loop = true;
        };
        SilentTyping.enabled = {
          enabled = true;
          showIcon = true;
          contextMenu = true;
          isEnabled = true;
        };
        SpotifyControls = {
          enabled = true;
          hoverControls = false;
        };
        USRBG = {
          enabled = true;
          voiceBackground = true;
        };
      };
    };
  };
}
