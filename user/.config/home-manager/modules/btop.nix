{ pkgs, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "cyberdream";
      vim_keys = true;
      disable_mouse = true;
      save_config_on_exit = false;
    };
    themes = {
      cyberdream = builtins.readFile "${pkgs.vimPlugins.cyberdream-nvim}/extras/btop/cyberdream.theme";
    };
  };
}
