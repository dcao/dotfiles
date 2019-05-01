# Until https://github.com/NixOS/nixpkgs/pull/57867 is merged...
{ stdenv, fetchFromGitHub, pkgconfig, which, qmake,
  qtbase, qtmultimedia, frei0r, opencolorio, hicolor-icon-theme, ffmpeg-full,
  CoreFoundation  }:

stdenv.mkDerivation {
  name = "olive-editor";
  version = "unstable-2019-04-20";

  src = fetchFromGitHub {
    owner = "olive-editor";
    repo = "olive";
    rev = "c5f63ec2c5511e4af0f4a5a839dbfd995bd77fd4";
    sha256 = "1nzig5flbc1h88cjrfcf296g19m7fchp7jmx8m1nzjkzhlx6297d";
  };

  nativeBuildInputs = [
    pkgconfig
    which
    qmake
  ];

  buildInputs = [
    ffmpeg-full
    opencolorio
    qtbase
    qtmultimedia
    qtmultimedia.dev
    hicolor-icon-theme
  ] ++ stdenv.lib.optional stdenv.isDarwin CoreFoundation
    ++ stdenv.lib.optional stdenv.isLinux frei0r;

  meta = with stdenv.lib; {
    description = "Professional open-source NLE video editor";
    homepage = "https://www.olivevideoeditor.org/";
    downloadPage = "https://www.olivevideoeditor.org/download.php";
    license = licenses.gpl3;
    maintainers = [ maintainers.balsoft ];
    platforms = platforms.unix;
  };
}
