{ inputs, ... }:

{
  # wayland.WindowManager.niri only available on HM 26.11+
  imports = [
    "${inputs.home-manager-unstable}/modules/services/window-managers/niri.nix"
  ];

  wayland.windowManager.niri = {
    enable = true;
    checkConfig = true;

    # niri kdl settings
    settings = {
      # Include Noctalia theming
      include = {
        _args = ["noctalia.kdl"];
        _props.optional = true;
      };

      # Omit CSD
      prefer-no-csd = {};

      # Input devices
      input = {
        keyboard = {
          # Empty section: niri fetches xkb settings from org.freedesktop.locale1
          xkb = {};
          # Enable numlock on startup
          numlock = {};
          # default 600
          repeat-delay = 300;
        };

        touchpad = {
          # Tap to click
          tap = {};
          natural-scroll = {};
        };
      };

      # Turn off hot corners
      gestures.hot-corners.off = {};

      # Cursor theme and size
      cursor = {
        xcursor-theme = "Bibata-Modern-Ice";
        xcursor-size  = 22;
      };

      # Gap sizes (theming managed through noctalia.kdl)
      layout = {
        # Gaps around windows in logical pixels
        gaps = 8;
        # Width of the focus ring
        focus-ring.width = 2;
      };

      # Skip hotkey overlay
      hotkey-overlay.skip-at-startup = {};

      # Blurred overview wallpaper
      layer-rule = {
        match._props.namespace = "^noctalia-backdrop";
        place-within-backdrop = true;
      };

      # Allow notification actions from Noctalia
      debug.honor-xdg-activation-with-invalid-serial = {};

      # Screenshot path (formatted by strftime)
      screenshot-path = "~/Pictures/Screenshots/Screenshot-%Y%m%d-%H%M%S.png";

      _children = [
        ### STARTUP PROGRAMS ###
        { spawn-at-startup = [ "noctalia" ]; }

        ### WINDOW RULES     ###
        {
          window-rule = {
            # Firefox Picture-in-Picture floating
            match._props = {
              app-id = "firefox$";
              title  = "^Picture-in-Picture$";
            };
            open-floating = true;
          };
        }
        {
          # Block KeepassXC from screen capture
          window-rule = {
            match._props.app-id = "^org[.]keepassxc[.]KeePassXC$";
            block-out-from = "screen-capture";
          };
        }
        {
          # Zed settings panel floating
          window-rule = {
            match._props.title = "^Zed — Settings$";
            open-floating = true;
          };
        }
        {
          # Alacritty default width 1/3
          window-rule = {
            match._props.app-id = "^Alacritty$";
            default-column-width.proportion = 0.3333;
          };
        }
        {
          # Rounded corners for all windows
          window-rule = {
            geometry-corner-radius = 8;
            clip-to-geometry = true;
            draw-border-with-background = false;
          };
        }
        {
          # Noctalia Settings panel floating
          window-rule = {
            match._props.app-id = "dev.noctalia.Noctalia";
            open-floating = true;
            default-column-width.fixed = 1080;
            default-window-height.fixed = 920;
          };
        }
      ];

      binds = {
        # Noctalia
        "Mod+D".spawn-sh = "noctalia msg panel-toggle launcher";
        "Mod+S".spawn-sh = "noctalia msg panel-toggle control-center";
        "Mod+0".spawn-sh = "noctalia msg session lock";
        "Mod+G".spawn-sh = "noctalia msg panel-toggle wallpaper";

        # Custom keybindings
        "Mod+T".spawn = "alacritty";
        "Mod+Return".spawn-sh = "niri msg action set-column-width \"66.67%\" && exec alacritty";
        "Mod+Shift+Q".spawn = "shutdown now";
        "Mod+Shift+S".screenshot = {};
        
        # Volume keys
        XF86AudioRaiseVolume = {
          _props.allow-when-locked = true;
          spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0";
        };
        XF86AudioLowerVolume = {
          _props.allow-when-locked = true;
          spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        };
        XF86AudioMute = {
          _props.allow-when-locked = true;
          spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        XF86AudioMicMute = {
          _props.allow-when-locked = true;
          spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };

        # Media keys
        XF86AudioPlay = {
          _props.allow-when-locked = true;
          spawn-sh = "playerctl play-pause";
        };
        XF86AudioStop = {
          _props.allow-when-locked = true;
          spawn-sh = "playerctl stop";
        };
        XF86AudioPrev = {
          _props.allow-when-locked = true;
          spawn-sh = "playerctl previous";
        };
        XF86AudioNext = {
          _props.allow-when-locked = true;
          spawn-sh = "playerctl next";
        };

        # Brightness keys
        XF86MonBrightnessUp = {
          _props.allow-when-locked = true;
          spawn-sh = "noctalia msg brightness-up";
        };
        XF86MonBrightnessDown = {
          _props.allow-when-locked = true;
          spawn-sh = "noctalia msg brightness-down";
        };

        # Overview and closing
        "Mod+O" = { _props.repeat = false; toggle-overview = {}; };
        "Mod+Q" = { _props.repeat = false; close-window = {}; };

        # Focusing
        "Mod+Left".focus-column-left = {};
        "Mod+Down".focus-window-down = {};
        "Mod+Up".focus-window-up = {};
        "Mod+Right".focus-column-right = {};
        "Mod+H".focus-column-left = {};
        "Mod+J".focus-window-down = {};
        "Mod+K".focus-window-up = {};
        "Mod+L".focus-column-right = {};
        "Mod+Home".focus-column-first = {};
        "Mod+End".focus-column-last = {};
        "Mod+WheelScrollRight".focus-column-right = {};
        "Mod+WheelScrollLeft".focus-column-left = {};
        
        # Moving
        "Mod+Ctrl+Left".move-column-left = {};
        "Mod+Ctrl+Down".move-window-down = {};
        "Mod+Ctrl+Up".move-window-up = {};
        "Mod+Ctrl+Right".move-column-right = {};
        "Mod+Ctrl+H".move-column-left = {};
        "Mod+Ctrl+J".move-window-down = {};
        "Mod+Ctrl+K".move-window-up = {};
        "Mod+Ctrl+L".move-column-right = {};
        "Mod+Ctrl+Home".move-column-to-first = {};
        "Mod+Ctrl+End".move-column-to-last = {};
        "Mod+Ctrl+WheelScrollRight".move-column-right = {};
        "Mod+Ctrl+WheelScrollLeft".move-column-left = {};
        
        # Monitor focusing
        "Mod+Shift+Left".focus-monitor-left = {};
        "Mod+Shift+Down".focus-monitor-down = {};
        "Mod+Shift+Up".focus-monitor-up = {};
        "Mod+Shift+Right".focus-monitor-right = {};
        "Mod+Shift+H".focus-monitor-left = {};
        "Mod+Shift+J".focus-monitor-down = {};
        "Mod+Shift+K".focus-monitor-up = {};
        "Mod+Shift+L".focus-monitor-right = {};

        # Moving columns through monitors
        "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = {};
        "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = {};
        "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = {};
        "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = {};
        "Mod+Shift+Ctrl+H".move-column-to-monitor-left = {};
        "Mod+Shift+Ctrl+J".move-column-to-monitor-down = {};
        "Mod+Shift+Ctrl+K".move-column-to-monitor-up = {};
        "Mod+Shift+Ctrl+L".move-column-to-monitor-right = {};

        # Workspace focusing
        "Mod+Page_Down".focus-workspace-down = {};
        "Mod+Page_Up".focus-workspace-up = {};
        "Mod+U".focus-workspace-down = {};
        "Mod+I".focus-workspace-up = {};
        "Mod+WheelScrollDown" = { _props.cooldown-ms = 150; focus-workspace-down = {}; };
        "Mod+WheelScrollUp" = { _props.cooldown-ms = 150; focus-workspace-up = {}; };
        
        # Moving columns through workspaces
        "Mod+Ctrl+Page_Down".move-column-to-workspace-down = {};
        "Mod+Ctrl+Page_Up".move-column-to-workspace-up = {};
        "Mod+Ctrl+U".move-column-to-workspace-down = {};
        "Mod+Ctrl+I".move-column-to-workspace-up = {};
        "Mod+Ctrl+WheelScrollDown" = { _props.cooldown-ms = 150; move-column-to-workspace-down = {}; };
        "Mod+Ctrl+WheelScrollUp" = { _props.cooldown-ms = 150; move-column-to-workspace-up = {}; };

        # Moving entire workspaces
        "Mod+Shift+Page_Down".move-workspace-down = {};
        "Mod+Shift+Page_Up".move-workspace-up = {};
        "Mod+Shift+U".move-workspace-down = {};
        "Mod+Shift+I".move-workspace-up = {};

        # Workspace focusing via numbers
        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;

        # Moving columns through workspaces via numbers
        "Mod+Ctrl+1".move-column-to-workspace = 1;
        "Mod+Ctrl+2".move-column-to-workspace = 2;
        "Mod+Ctrl+3".move-column-to-workspace = 3;
        "Mod+Ctrl+4".move-column-to-workspace = 4;
        "Mod+Ctrl+5".move-column-to-workspace = 5;
        "Mod+Ctrl+6".move-column-to-workspace = 6;
        "Mod+Ctrl+7".move-column-to-workspace = 7;
        "Mod+Ctrl+8".move-column-to-workspace = 8;
        "Mod+Ctrl+9".move-column-to-workspace = 9;

        # Moving windows in and out of columns
        "Mod+BracketLeft".consume-or-expel-window-left = {};
        "Mod+BracketRight".consume-or-expel-window-right = {};
        
        # Consume one window from the right to the bottom of the focused column.
        "Mod+Comma".consume-window-into-column = {};
        # Expel the bottom window from the focused column to the right.
        "Mod+Period".expel-window-from-column = {};
        
        # Cycle through widths set in preset-column-widths.
        "Mod+R".switch-preset-column-width = {};
        # Cycling through the presets in reverse order is also possible.
        "Mod+Shift+R".switch-preset-column-width-back = {};
        
        "Mod+Ctrl+Shift+R".switch-preset-window-height = {};
        "Mod+Ctrl+R".reset-window-height = {};

        # Maximizing, fullscreening and maximizing to edges
        "Mod+F".maximize-column = {};
        "Mod+Shift+F".fullscreen-window = {};
        "Mod+M".maximize-window-to-edges = {};
        
        # Expand the focused column to space not taken up by other fully visible columns.
        # Makes the column "fill the rest of the space".
        "Mod+Ctrl+F".expand-column-to-available-width = {};
        
        "Mod+C".center-column = {};
        
        # Center all fully visible columns on screen.
        "Mod+Ctrl+C".center-visible-columns = {};
        
        # Finer width adjustments
        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        
        # Finer height adjustments when in column with other windows.
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";
        
        # Move the focused window between the floating and the tiling layout.
        "Mod+V".toggle-window-floating = {};
        "Mod+Shift+V".switch-focus-between-floating-and-tiling = {};
        
        # Toggle tabbed column display mode.
        # Windows in this column will appear as vertical tabs,
        # rather than stacked on top of each other.
        "Mod+W".toggle-column-tabbed-display = {};
        
        # Screenshotting
        "Print".screenshot = {};
        "Ctrl+Print".screenshot-screen = {};
        "Alt+Print".screenshot-window = {};
        
        # Applications such as remote-desktop clients and software KVM switches may
        # request that niri stops processing the keyboard shortcuts defined here
        # so they may, for example, forward the key presses as-is to a remote machine.
        # It's a good idea to bind an escape hatch to toggle the inhibitor,
        # so a buggy application can't hold your session hostage.
        #
        # The allow-inhibiting=false property can be applied to other binds as well,
        # which ensures niri always processes them, even when an inhibitor is active.
        "Mod+Escape" = { _props.allow-inhibiting = false; toggle-keyboard-shortcuts-inhibit = {}; };
        
        # The quit action will show a confirmation dialog to avoid accidental exits.
        "Mod+Shift+E".quit = {};
        "Ctrl+Alt+Delete".quit = {};
        
        # Powers off the monitors. To turn them back on, do any input like
        # moving the mouse or pressing any other key.
        "Mod+Shift+P".power-off-monitors = {};
      };
    };
  };
}
