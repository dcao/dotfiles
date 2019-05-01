{ stdenv }:

stdenv.mkDerivation rec {
  name = "world-wall-2019-04-22";
  src = ./world.png;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/artwork/gnome
    ln -s $src $out/share/artwork/gnome/world.png
    # KDE
    mkdir -p $out/share/wallpapers/${name}/contents/images
    ln -s $src $out/share/wallpapers/${name}/contents/images/world.png
    cat >>$out/share/wallpapers/${name}/metadata.desktop <<_EOF
[Desktop Entry]
Name=${name}
X-KDE-PluginInfo-Name=${name}
_EOF
  '';
}
