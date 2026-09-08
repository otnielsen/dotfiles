{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "vaapi";
      profile = "high-quality";
      video-sync = "display-resample";
      interpolation = true;
      hdr-reference-white = 100;
      fullscreen = true;
      osc = false;
      audio-display = false;
      slang = "en";
      alang = builtins.concatStringsSep "," [
        "ja"
        "en"
      ];
      ytdl-raw-options = builtins.concatStringsSep "," [
        ''format-sort="+hdr"''
      ];
      ytdl-format = "bv*[width<=2560][height<=1440]+ba/b[width<=2560][height<=1440]";
    };
    scripts = with pkgs.mpvScripts; [ sponsorblock-minimal ];
    scriptOpts = {
      sponsorblock_minimal = {
        categories = builtins.concatStringsSep ";" [
          "sponsor"
          "selfpromo"
          "interaction"
          "intro"
          "outro"
          "preview"
          "hook"
          "filler"
        ];
        hash = "true";
      };
    };
  };
}
