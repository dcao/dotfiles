# https://github.com/markus1189/dyalog-nixos/blob/master/ride/ride.nix
{
  alsaLib,
  atk,
  cairo,
  cups,
  dbus_daemon,
  dpkg,
  electron,
  expat,
  fetchurl,
  fontconfig,
  gdk_pixbuf,
  glib,
  glibc,
  gnome2 ,
  gtk3,
  libpthreadstubs,
  libxcb,
  makeWrapper,
  nspr,
  nss,
  pango,
  runtimeShell,
  stdenv,
  writeScript,
  xorg
}:

let
  libPath = stdenv.lib.makeLibraryPath (with xorg; [
    alsaLib
    atk
    cairo
    cups
    dbus_daemon.lib
    expat
    fontconfig
    gdk_pixbuf
    glib
    glibc
    gnome2.GConf
    pango
    gtk3
    libpthreadstubs
    libxcb
    nspr
    nss
    stdenv.cc.cc.lib

    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXScrnSaver
    libXtst
  ]);
  electronLauncher = writeScript "rideWrapper" ''
    #!${runtimeShell}
    set -e
    ${electron}/bin/electron TODO/resources/app
  '';
  drv = stdenv.mkDerivation rec {
    name = "ride-${version}";

    version = "4.2.3437-1";

    shortVersion = stdenv.lib.concatStringsSep "." (stdenv.lib.take 2 (stdenv.lib.splitString "." version));

    # deal with 4.2.3437 having a '-1' suffix...
    cleanedVersion = builtins.replaceStrings ["-1"] [""] version;

    src = fetchurl {
      url = "https://github.com/Dyalog/ride/releases/download/v${cleanedVersion}/ride-${version}_amd64.deb";
      sha256 = "0pw51z8kifmbss6vnljhskf9k02iw52p5r3rfj9kaapprifdk66i";
    };

    nativeBuildInputs = [ dpkg ];

    buildInputs = [ makeWrapper ];

    unpackPhase = "dpkg-deb -x $src .";

    installPhase = ''
      mkdir -p $out/whatever
      mv opt/ride-${shortVersion}/* $out/whatever/

      mkdir $out/bin
      cp ${electronLauncher} $out/bin/ride
      sed -i -e "s|TODO|$out/whatever|" $out/bin/ride
    '';

    preFixup = ''
      for lib in $out/whatever/*.so; do
        patchelf --set-rpath "${libPath}" $lib
      done

      for bin in $out/whatever/Ride-${shortVersion}; do
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
                 --set-rpath "$out/whatever:${libPath}" \
                 $bin
      done
    '';
  };
in
  drv
