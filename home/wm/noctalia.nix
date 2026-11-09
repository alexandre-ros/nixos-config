{ inputs, config, pkgs-unstable, ... }: 

{
  # programs.noctalia only available on HM 26.11+ (unstable)
  imports = [
    "${inputs.home-manager-unstable}/modules/programs/noctalia/default.nix"
  ];
  
  programs.noctalia = {
    enable = true;
    package = pkgs-unstable.noctalia;
    checkConfig = true;

    settings = {
      # Enable backdrop for wallpaper
      backdrop.enabled = true;

      # Noctalia bar
      bar.default = {
        # Customization
        background_opacity = 0;
        capsule_radius = 4;
        compositor_blur = true;
        font_family = "JetBrainsMono NF";
        font_weight = 500;
        margin_ends = 0;
        radius = 0;
        scale = 1.1;
        shadow = false;
        thickness = 26;
        
        # Layout
        start  = [
          "session" 
          "workspaces"
        ];
        center = [ 
          "date" 
        ];
        end = [
          "tray"
          "blank"
          "weather"
          "volume"
          "brightness"
          "network"
          "bluetooth"
          "battery"
          "blank"
          "clock"
        ];
      };

      # Control center
      control_center.width = 730;
      location.address = "Barcelona, Spain";
      
      # Widgets
      widget = {
        workspaces = {
          show_labels = false;
          pill_scale = 0.9;
        };
        date.format  = "{:%A,%e %B}";
        clock.format = "{:%H:%M %Z}";
        blank = {
          type = "spacer";
          length = 10;
        };
      };

      # Shell
      shell = {
        avatar_path = "${config.home.homeDirectory}/.face";
        font_family = "Inter";
      };

      # Other settings
      desktop_widgets.enabled = false;
      lockscreen_widgets.enabled = false;
      nightlight.enabled = true;
      notification.history_retention_hours = 6;
      
      # Themes and wallpaper
      theme = {
        builtin           = "Tokyo-Night";
        community_palette = "Ayu Green";
        mode              = "dark";
        source            = "community";
        
        # Theme templates
        templates = {
          builtin_ids   = [ "alacritty" "gtk4" "niri" "qt" ];
          community_ids = [ "zed" "tauon" ];
        };
      };
      
      # Wallpaper
      wallpaper = {
        directory    = "${config.home.homeDirectory}/Pictures/Wallpapers";
        default.path = "${config.home.homeDirectory}/Pictures/Wallpapers/Morskie Oko.jpg";
      };
    };
  };
}