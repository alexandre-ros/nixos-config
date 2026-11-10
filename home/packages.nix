{ pkgs, pkgs-unstable, ...}:

{
  # Default flags for special packages
  xdg.desktopEntries."dolphin-emu" = {
    name = "Dolphin Emulator";
    genericName = "Wii/GameCube Emulator";
    exec = "dolphin-emu --platform wayland";
    icon = "dolphin-emu";
    terminal = false;
    categories = [ "Game" "Emulator" ];
  };

  # User packages
  home.packages = with pkgs;
    [
      alttpr-opentracker
      android-tools
      bison
      calibre
      cargo
      cbqn
      clippy
      difftastic
      dolphin-emu
      element-desktop
      erlang
      exercism
      ffmpeg
      gcc16
      gimp
      git
      joplin-desktop
      keepassxc
      libgcc
      libreoffice-fresh
      love
      lua5_5_compat
      lynx
      mullvad-vpn
      newsboat
      nitch
      nixos-icons
      openssl
      picard
      pkgs-unstable.anki-bin
      pkgs-unstable.tauon
      pkgs-unstable.uiua-unstable
      playerctl
      qbittorrent
      qemu
      qusb2snes
      rmg-wayland
      rustc
      spotdl
      swi-prolog
      telegram-desktop
      texmaker
      tree
      unzip
      virt-viewer
      weechat
      wineWow64Packages.stable
      wkhtmltopdf
      xournalpp
      yt-dlp
      zulu

      # KDE Packages
      kdePackages.kleopatra
      kdePackages.okular
      kdePackages.poppler

      # Python 3.14 packages
      (python314.withPackages (
        ps: with ps; [
          apscheduler
          asn1crypto
          discordpy
          geopandas
          matplotlib
          numpy
          pandas
          pip
          pydantic
          python-dotenv
          python-telegram-bot
          pyyaml
          requests
          requests-toolbelt
          rich
        ]
      ))

      # Haskell packages
      haskellPackages.cabal-install
      haskellPackages.ghc
      haskellPackages.hlint

      # LaTeX packages
      (texlive.combine {
        inherit (texlive)
          cabin
          enumitem
          fancyhdr
          fira
          fontawesome5
          fontaxes
          geometry
          hyperref
          lastpage
          scheme-medium
          soul
          titlesec
          totalcount
          xcolor
          xhfill
          ;
      })
    ];
}
