{ pkgs-unstable, ...}:

{
  # Jujutsu VCS btw
  programs.jujutsu = {
    enable   = true;
    package  = pkgs-unstable.jujutsu;
    settings = {
      # User settings
      user.email         = "alexandre-ros@tuta.io";
      user.name          = "Alexandre Ros";
      ui.paginate        = "never";
      ui.default-command = "log";

      # Colors and UI
      colors.conflict_prompt = {
        fg = "red";
        bold = true;
      };
      
      template-aliases = {
        "format_short_signature(signature)" = "signature.email().local()";
      };

      # Difftastic
      ui.diff-formatter = [ "difft" "--color=always" "$left" "$right" ];
    };
  };
}