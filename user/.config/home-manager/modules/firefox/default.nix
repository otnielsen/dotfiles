{ config, ... }:
{
  programs.firefox = {
    enable = true;
    profiles."${config.home.username}" = {
      extraConfig = builtins.readFile ./user.js;
      userContent = ./userContent.css;
      search = {
        default = "ddg";
        force = true;
      };
    };
    policies = {
      ExtensionSettings = {
        "addon@darkreader.org" = {
          installation_mode = "normal_installed";
          updates_disabled = false;
          private_browsing = true;
          default_area = "navbar";
        };
        "idcac-pub@guus.ninja" = {
          installation_mode = "normal_installed";
          updates_disabled = false;
          private_browsing = true;
          default_area = "menupanel";
        };
        "sponsorBlocker@ajay.app" = {
          installation_mode = "normal_installed";
          updates_disabled = false;
          private_browsing = true;
          default_area = "menupanel";
        };
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          updates_disabled = false;
          private_browsing = true;
          default_area = "menupanel";
        };
        "vpn@proton.ch" = {
          installation_mode = "normal_installed";
          updates_disabled = false;
          private_browsing = true;
          default_area = "navbar";
        };
        "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = {
          installation_mode = "normal_installed";
          updates_disabled = false;
          private_browsing = true;
          default_area = "menupanel";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          installation_mode = "normal_installed";
          updates_disabled = false;
          private_browsing = true;
          default_area = "menupanel";
        };
      };
    };
  };
}
