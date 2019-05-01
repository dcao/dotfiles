{ stdenv, fetchurl, unzip, wine, bash, makeWrapper, ... }:

let
  wine-wow = wine.override {
    wineBuild = "wineWow";
  };
in
stdenv.mkDerivation rec {
  version = "1.28.04.00";
  name = "openmpt-${version}";

  src = fetchurl {
    url = "https://download.openmpt.org/OpenMPT-${version}-x64.zip";
    sha256 = "0g7vrkwvhk5vcj1knd111ydkw6f8sd83fv3w4f0sd0fi6grrq8w6";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  propagatedBuildInputs = [ wine-wow ];

  installPhase = ''
    start="$(pwd)"
    mkdir -p $out/bin
    cp -r $start $out/
    echo -e "#!/usr/bin/env bash\n${wine-wow}/bin/wine64 $out/OpenMPT-${version}/mptrack.exe" > $out/bin/mptrack
    chmod +x $out/bin/mptrack
  '';

  meta = {
    homepage = https://openmpt.org;
    license = with stdenv.lib.licenses; [ bsd3 ];
    description = "Music tracker software.";
    platforms = [ "x86_64-linux" ];
  };
}
