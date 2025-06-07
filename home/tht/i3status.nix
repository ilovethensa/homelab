{...}:

{ programs.i3status = {
  enable = true;
  # Use the order and settings defined below, not the i3status defaults.
  enableDefault = false;

  general = {
    colors = true;
    interval = 5;
  };

  # The `order` from your config is mapped to the `position` attribute of each module.
  # Lower numbers appear first (to the left).
  modules = {
    # This is the new module replacing ipv6
    "cpu_temperature 1" = {
      position = 10;
      settings = {
        format = "T: %degrees °C";
        # Note: Make sure this path is correct for your specific hardware.
        path = "/sys/class/hwmon/hwmon1/temp1_input";
      };
    };

    "wireless _first_" = {
      position = 20;
      settings = {
        format_up = "W: (%quality at %essid) %ip";
        format_down = "W: down";
      };
    };

    "ethernet _first_" = {
      position = 30;
      settings = {
        format_up = "E: %ip (%speed)";
        format_down = "E: down";
      };
    };

    "battery all" = {
      position = 40;
      settings = {
        format = "%status %percentage %remaining";
      };
    };

    "disk /nix" = {
      position = 50;
      settings = {
        format = "%avail";
      };
    };

    "load" = {
      position = 60;
      settings = {
        format = "%1min";
      };
    };

    "memory" = {
      position = 70;
      settings = {
        format = "%used | %available";
        format_degraded = "MEMORY < %available";
        threshold_degraded = "1G";
      };
    };

    "tztime local" = {
      position = 80;
      settings = {
        format = "%Y-%m-%d %H:%M:%S";
      };
    };
  };
};
}
