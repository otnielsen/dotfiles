// ==UserScript==
// @name  youtube annoyances
// @grant GM_getValue
// @grant GM_setValue
// @match https://www.youtube.com/*
// ==/UserScript==

(() => {
  "use strict";

  let selectedRes = GM_getValue("resolution", "hd1080");

  const allRes = {
    highres: 4320,
    hd2160: 2160,
    hd1440: 1440,
    hd1080: 1080,
    hd720: 720,
    large: 480,
    medium: 360,
    small: 240,
    tiny: 144,
  };

  const selectDiv = document.createElement("div");
  selectDiv.style.marginLeft = "auto";
  selectDiv.style.marginRight = "auto";
  selectDiv.style.colorScheme = "dark";

  const select = document.createElement("select");
  for (const level of Object.keys(allRes)) {
    const option = document.createElement("option");
    option.textContent = `${allRes[level]}p`;
    option.value = level;
    if (level === selectedRes) {
      option.selected = true;
    }
    select.append(option);
  }
  selectDiv.append(select);

  const settingsHeaderObserver = new MutationObserver((records) => {
    for (const record of records) {
      for (const node of record.addedNodes) {
        if (
          node.nodeType === 1 &&
          node.classList.contains("ytp-quality-menu")
        ) {
          const header = node.querySelector(".ytp-panel-header");
          if (header && !header.contains(selectDiv)) {
            header.append(selectDiv);
          }
        }
      }
    }
  });

  function onUrlChange() {
    settingsHeaderObserver.disconnect();
    if (!location.pathname.startsWith("/watch")) return;

    new MutationObserver((_, observer) => {
      const player = document.getElementById("movie_player");
      const videoRes = player.getAvailableQualityLevels();
      const manager = document.querySelector("yt-playlist-manager");
      const autonavButton = document.querySelector(
        ".ytp-autonav-toggle-button",
      );
      if (!player || !videoRes.length || !manager || !autonavButton) return;

      const setResolution = () => {
        let largestRes = "tiny";

        for (const res of videoRes) {
          if (res === selectedRes) {
            largestRes = selectedRes;
            break;
          } else if (allRes[res] > allRes[largestRes]) {
            largestRes = res;
          }
        }

        player.setPlaybackQualityRange(largestRes, largestRes);
        player.setPlaybackQuality(largestRes);
      };
      setResolution();

      select.onchange = (event) => {
        selectedRes = event.target.value;
        GM_setValue("resolution", selectedRes);
        setResolution();
      };

      settingsHeaderObserver.observe(
        player.querySelector(".ytp-settings-menu"),
        {
          childList: true,
          subtree: true,
        },
      );

      player.setDrcUserPreference(0);
      player.setVoiceBoostUserPreference(1);

      manager.polymerController.canAutoAdvance_ = false;

      const intervalId = setInterval(() => {
        if (autonavButton.ariaChecked === "true") autonavButton.click();
        if (autonavButton.ariaChecked === "false") clearInterval(intervalId);
      }, 500);

      observer.disconnect();
    }).observe(document.body, {
      childList: true,
      subtree: true,
    });
  }

  window.addEventListener("yt-navigate-finish", onUrlChange);
})();
