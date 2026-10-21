{ pkgs, ...}: 

{
  imports = [
    ./niri.nix
    ./noctalia.nix
  ];
  
  # Some backgrounds
  home.file."Pictures/Wallpapers/disco.png".source = pkgs.fetchurl {
    url = "https://i.redd.it/43a0onoy326h1.png";
    hash = "sha256-fs03mu9Csmn8eMaVc8uQGcQqh/1scqaRqeQ6tjP/MeU=";
  };
  
  # Avatar
  home.file.".face".source = ./avatar.jpg;
}
