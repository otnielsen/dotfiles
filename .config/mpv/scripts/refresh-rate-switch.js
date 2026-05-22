function find_in_array(arr, callback) {
  var i;
  for (i = 0; i < arr.length; i++) {
    if (callback(arr[i])) {
      return arr[i];
    }
  }
}

function filter_array(arr, callback) {
  var filtered_arr = [];
  var i;
  for (i = 0; i < arr.length; i++) {
    if (callback(arr[i])) {
      filtered_arr.push(arr[i]);
    }
  }
  return filtered_arr;
}

function gcd(a, b) {
  return b === 0 ? a : gcd(b, a % b);
}

function get_best_mode(modes, current_mode, fps) {
  var fps_rounded = Math.round(fps);

  var lowest_q_modes = [];
  var lowest_q = Infinity;
  modes.forEach(function (mode) {
    var q = fps_rounded / gcd(Math.round(mode.refreshRate), fps_rounded);

    if (q < lowest_q) {
      lowest_q = q;
      lowest_q_modes = [mode];
    } else if (q === lowest_q) {
      lowest_q_modes.push(mode);
    }
  });

  var i;
  if (current_mode) {
    for (i = 0; i < lowest_q_modes.length; i++) {
      if (lowest_q_modes[i].id === current_mode.id) return;
    }
  }

  lowest_q_modes.sort(function (a, b) {
    return b.refreshRate - a.refreshRate;
  });

  highest_rate = Math.round(lowest_q_modes[0].refreshRate);

  lowest_q_modes = filter_array(lowest_q_modes, function (mode) {
    return Math.round(mode.refreshRate) === highest_rate;
  });

  var lowest_error_mode = null;
  var lowest_error = Infinity;
  lowest_q_modes.forEach(function (mode) {
    var multiple = Math.round(mode.refreshRate) / fps_rounded;
    var optimal_rate = fps * multiple;
    var error = Math.abs(mode.refreshRate - optimal_rate);

    if (error < lowest_error) {
      lowest_error = error;
      lowest_error_mode = mode;
    }
  });

  return lowest_error_mode;
}

function Display(name, output_modes, default_mode, current_mode) {
  this.name = name;
  this.output_modes = output_modes;
  this.default_mode = default_mode;
  this.current_mode = current_mode;
}

function kde_wayland(display_names) {
  var r = mp.command_native({
    name: "subprocess",
    playback_only: false,
    capture_stdout: true,
    args: ["kscreen-doctor", "--json"],
  });

  if (r.status !== 0) return;

  var outputs = JSON.parse(r.stdout).outputs;
  var output = find_in_array(outputs, function (output) {
    return display_names === output.name;
  });
  if (output === undefined) return;

  var mode = find_in_array(output.modes, function (mode) {
    return mode.id === output.currentModeId;
  });

  if (mode === undefined) return;

  var mode_width = mode.size.width;
  var mode_height = mode.size.height;

  modes_same_size = filter_array(output.modes, function (mode) {
    return mode.size.width === mode_width && mode.size.height === mode_height;
  });

  if (modes_same_size.length === 0) return;

  return new Display(output.name, modes_same_size, mode, mode);
}

var set_mode_cmd;
var output_func;
var current_container_fps;
var current_output;
var currently_fullscreen;

function set_mode(mode, pause) {
  r = mp.command_native({
    name: "subprocess",
    playback_only: false,
    args: set_mode_cmd(current_output, mode),
  });
  if (r.status === 0) {
    current_output.current_mode = mode;

    if (pause && mp.get_property_bool("pause") === false) {
      mp.set_property_bool("pause", true);
      setTimeout(function () {
        mp.set_property_bool("pause", false);
      }, 1000);
    }
  }
}

function set_optimal_refresh_rate() {
  var best_mode = get_best_mode(
    current_output.output_modes,
    current_output.current_mode,
    current_container_fps
  );
  if (best_mode !== undefined) set_mode(best_mode, true);
}

function on_fps_change(_, fps) {
  if (!fps || fps === current_container_fps) return;
  current_container_fps = fps;

  if (currently_fullscreen === true && current_output)
    set_optimal_refresh_rate();
}

function on_display_change(_, display_names) {
  if (
    !display_names ||
    (current_output && current_output.name === display_names)
  )
    return;

  if (display_names.indexOf(",") !== -1) {
    mp.msg.warn("Window covers multiple displays, which may cause stuttering.");
    return;
  }

  var output = output_func(display_names);
  if (output === undefined) return;
  if (
    current_output &&
    current_output.default_mode.id !== current_output.current_mode.id
  )
    set_mode(current_output.default_mode, false);

  if (Math.round(output.default_mode.refreshRate) > 120) {
    current_output = null;
  } else {
    current_output = output;
    if (currently_fullscreen && current_container_fps)
      set_optimal_refresh_rate();
  }
}

function on_fullscreen_change(_, fullscreen) {
  switch (fullscreen) {
    case true: {
      currently_fullscreen = true;
      if (current_output && current_container_fps) set_optimal_refresh_rate();
      break;
    }
    case false:
      currently_fullscreen = false;
      if (
        current_output &&
        current_output.default_mode.id !== current_output.current_mode.id
      )
        set_mode(current_output.default_mode, true);
      break;
  }
}

function main() {
  switch (mp.utils.getenv("XDG_SESSION_TYPE")) {
    case "wayland":
      switch (mp.utils.getenv("XDG_CURRENT_DESKTOP")) {
        case "KDE":
          output_func = kde_wayland;
          set_mode_cmd = function (output, mode) {
            return [
              "kscreen-doctor",
              "output." + output.name + ".mode." + mode.id,
            ];
          };
          break;
        default:
          return;
      }
      break;
    default:
      return;
  }

  mp.observe_property("container-fps", "number", on_fps_change);
  mp.observe_property("display-names", "string", on_display_change);
  mp.observe_property("fullscreen", "bool", on_fullscreen_change);
  mp.register_event("shutdown", function () {
    if (
      current_output &&
      current_output.default_mode.id !== current_output.current_mode.id
    )
      set_mode(current_output.default_mode, false);
  });
}

main();
