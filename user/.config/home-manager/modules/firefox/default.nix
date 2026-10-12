{ config, ... }:

let
  importedLists = [
    "https://raw.githubusercontent.com/fmhy/FMHYFilterlist/main/filterlist.txt"
    "https://raw.githubusercontent.com/mchangrh/yt-neuter/main/filters/sponsorblock.txt"
  ];
in
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
      "3rdparty".Extensions = {
        "uBlock0@raymondhill.net".adminSettings = {
          userSettings = {
            inherit importedLists;
          };
          selectedFilterLists = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "easylist"
            "easyprivacy"
            "urlhaus-1"
            "plowe-0"
            "fanboy-cookiemonster"
            "ublock-cookies-easylist"
          ] ++ importedLists;
          userFilters = ''
            *$removeparam=utm_source
            ||store.steampowered.com^$removeparam=snr
            ||*.cfd^
            ||youtube.com/watch^$removeparam=pp
            youtube.com##.annotation
            ! YouTube ambient mode
            youtube.com###cinematics
            youtube.com##.ytp-autonav-toggle
            ! Google signin popup
            ###credential_picker_container
          '';
        };
      };
    };
  };
}
