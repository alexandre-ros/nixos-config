{
  imports = [
    ./fonts.nix
    ./packages.nix
    ./programs/alacritty.nix
    ./programs/gnupg.nix
    ./programs/gtk-qt.nix
    ./programs/mozilla.nix
    ./programs/mpv.nix
    ./programs/neovim.nix
    ./programs/retroarch.nix
    ./programs/shell.nix
    ./programs/starship.nix
    ./programs/vcs.nix
    ./programs/wallpapers.nix
    ./programs/zed.nix
    ./wm/wm.nix
  ];
  
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  # udiskie mount daemon
  services.udiskie.enable = true;

  # EDITOR environment variable
  home.sessionVariables.EDITOR = "vim";

  home.stateVersion = "24.05";
}
