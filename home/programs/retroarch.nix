{
  programs.retroarch = {
    enable = true;
    cores.mgba.enable        = true;
    cores.snes9x.enable      = true;
    cores.mupen64plus.enable = true;
    settings = {
      pause_nonactive    = "false";
      network_cmd_enable = "true";
      video_vsync        = "false";
    };
  };
}