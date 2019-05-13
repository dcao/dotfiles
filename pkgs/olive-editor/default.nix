# Until https://github.com/NixOS/nixpkgs/pull/57867 is merged...
{ stdenv, fetchFromGitHub, pkgconfig, which, cmake, qttools,
  qtbase, qtmultimedia, frei0r, opencolorio, hicolor-icon-theme, ffmpeg-full,
  CoreFoundation  }:

stdenv.mkDerivation {
  name = "olive-editor";
  version = "unstable-2019-05-10";

  src = fetchFromGitHub (import ./metadata.nix);

  nativeBuildInputs = [
    pkgconfig
    which
    cmake
  ];

  buildInputs = [
    ffmpeg-full
    frei0r
    opencolorio
    qtbase
    qtmultimedia
    qtmultimedia.dev
    qttools
    hicolor-icon-theme
  ] ++ stdenv.lib.optional stdenv.isDarwin CoreFoundation;

  meta = with stdenv.lib; {
    description = "Professional open-source NLE video editor";
    homepage = "https://www.olivevideoeditor.org/";
    downloadPage = "https://www.olivevideoeditor.org/download.php";
    license = licenses.gpl3;
    maintainers = [ maintainers.balsoft ];
    platforms = platforms.unix;
  };
}
