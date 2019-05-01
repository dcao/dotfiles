{ stdenv, fetchFromGitHub, bash }:

stdenv.mkDerivation rec {
  name = "imgur-sh-${version}";
  version = "9";

  src = fetchFromGitHub {
    owner = "tremby";
    repo = "imgur.sh";
    rev = "08f9a17141fdfea1e4139de90146bd20c6bf2a2b";
    sha256 = "0r53gr154mk7lh0mmjf4j87yx7xi6jf8hzzlgjg7cs250g25axrd";
  };

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/imgur.sh $out/bin/
  '';
}
