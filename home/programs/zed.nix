{ pkgs, hostname, unstablePkgs, ...}: 

{
  # Zed IDE
  programs.zed-editor = {
    enable  = true;
    package = unstablePkgs.zed-editor;
  
    extraPackages = with pkgs; [
      lua-language-server
      nil
      nixd
      rust-analyzer
    ];

    userSettings =
      let
        fontsize = {
          Hyrule  = { txt = 12; ui = 15; };
          Termina = { txt = 13; ui = 16; };
        }.${hostname};
      in
      {
        autosave.after_delay.milliseconds = 1000;
        base_keymap                       = "VSCode";
        buffer_font_family                = "JetBrainsMono Nerd Font";
        buffer_font_size                  = fontsize.txt;
        code_lens                         = "on";
        cursor_blink                      = true;
        disable_ai                        = true;
        session.trust_all_worktrees       = true;
        ui_font_size                      = fontsize.ui;
        vim_mode                          = true;
        
        languages = {
          "Nix".tab_size    = 2;
          "Prolog".tab_size = 2;
        };
        project_panel = {
          dock          = "left";
          default_width = 300;
        };
        terminal = {
          dock      = "right";
          font_size = fontsize.txt;
        };
        telemetry = {
          metrics     = false;
          diagnostics = false;
        };
        theme = {
          mode  = "system";
          dark  = "Noctalia Dark";
          light = "Noctalia Light";
        };
        icon_theme = {
          mode  = "system";
          dark  = "Colored Zed Icons Theme Dark";
          light = "Colored Zed Icons Theme Light";
        };
        profiles.Uiua.settings = {
          buffer_font_family = "Uiua386";
          buffer_font_size   = fontsize.txt + 5;
          terminal.font_size = fontsize.txt + 5;
          autosave           = "off";
        };
      };

    extensions = [
      # Themes
      "andromeda"
      "catppuccin"
      "colored-zed-icons-theme"
      "everforest"
      "github-theme"
      "nvim-nightfox"
      "tokyo-night"

      # Grammars
      "bqn"
      "git-firefly"
      "haskell"
      "kdl"
      "lua"
      "make"
      "nix"
      "prolog"
      "toml"
      "uiua"
    ];
  };
}