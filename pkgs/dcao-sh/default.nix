{ stdenv }:

stdenv.mkDerivation rec {
  name = "dcao-sh";

  src = ./src;

  installPhase = ''
    mkdir -p "$out/bin"
    cp -R "$src/." "$out/bin/"
  '';
}
