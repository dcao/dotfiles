{ stdenv, fetchurl, makeWrapper, jre, jdk, gcc, xorg
, htmlunit-driver, chromedriver, chromeSupport ? true }:

with stdenv.lib;

let
  arch = if stdenv.system == "x86_64-linux" then "amd64"
         else if stdenv.system == "i686-linux" then "i386"
         else "";

in stdenv.mkDerivation rec {
  name = "selenium-server-standalone-${version}";
  version = "2.53.1";

  src = fetchurl {
    url = "http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-${version}.jar";
    sha256 = "1cce6d3a5ca5b2e32be18ca5107d4f21bddaa9a18700e3b117768f13040b7cf8";
  };

  unpackPhase = "true";

  buildInputs = [ jre makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/lib/${name}
    cp $src $out/share/lib/${name}/${name}.jar
    makeWrapper ${jre}/bin/java $out/bin/selenium-server \
      --add-flags "-cp ${htmlunit-driver}/share/lib/${htmlunit-driver.name}/${htmlunit-driver.name}.jar:$out/share/lib/${name}/${name}.jar" \
      --add-flags ${optionalString chromeSupport "-Dwebdriver.chrome.driver=${chromedriver}/bin/chromedriver"} \
      --add-flags "org.openqa.grid.selenium.GridLauncher"
  '';

  meta = {
    homepage = https://code.google.com/p/selenium;
    description = "Selenium Server for remote WebDriver";
    maintainers = with maintainers; [ coconnor offline ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
