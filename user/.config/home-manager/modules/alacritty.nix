{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        import = [
          "${pkgs.vimPlugins.cyberdream-nvim}/extras/alacritty/cyberdream.toml"
        ];
      };
      window = {
        decorations = "none";
        startup_mode = "Fullscreen";
      };
      keyboard.bindings = [
        {
          key = "F11";
          action = "ToggleFullscreen";
        }
      ];
      mouse = {
        hide_when_typing = true;
      };
    };
  };
}
