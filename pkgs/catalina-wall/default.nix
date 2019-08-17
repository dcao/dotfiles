{ stdenv }:

stdenv.mkDerivation rec {
  name = "catalina-wall-2019-08-01";
  src = ./catalina.jpg;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/artwork/gnome
    ln -s $src $out/share/artwork/gnome/catalina.jpg
    # KDE
    mkdir -p $out/share/wallpapers/${name}/contents/images
    ln -s $src $out/share/wallpapers/${name}/contents/images/catalina.jpg
    cat >>$out/share/wallpapers/${name}/metadata.desktop <<_EOF
[Desktop Entry]
Name=${name}
X-KDE-PluginInfo-Name=${name}
_EOF
  '';
}
