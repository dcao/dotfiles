{ stdenv, fetchurl, dpkg, makeWrapper, buildFHSUserEnv, curl
, gnome3, gtk3, gdk_pixbuf, cairo, libjpeg_original, glib, gnome2, libGLU_combined
, nvidia_cg_toolkit, zlib, openssl, portaudio, libuuid, alsaLib, openldap, libjack2
}:
let
  libjpeg_original_fix = libjpeg_original.overrideAttrs (oldAttrs: {
    src = fetchurl {
      url = https://www.ijg.org/files/jpegsrc.v8d.tar.gz;
      sha256 = "1cz0dy05mgxqdgjf52p54yxpyy95rgl30cnazdrfmw7hfca9n0h0";
    };
  });

  fullPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc
    alsaLib
    gtk3
    gdk_pixbuf
    cairo
    curl
    libjpeg_original_fix
    glib
    gnome2.pango
    libGLU_combined
    libjack2
    libuuid
    openldap
    nvidia_cg_toolkit
    zlib
    openssl
    portaudio
  ];

  lightworks = stdenv.mkDerivation rec {
    version = "14.5.0";
    name = "lightworks-${version}";

    src =
      if stdenv.hostPlatform.system == "x86_64-linux" then
        fetchurl {
          url = "https://downloads.lwks.com/v14-5-new/lightworks-14.5.0-amd64.deb";
          sha256 = "0kvnxvxcgymih5n5x8nmclmqm7wx51gkylznczx928mf5k18sn2r";
        }
      else throw "${name} is not supported on ${stdenv.hostPlatform.system}";

    buildInputs = [ dpkg makeWrapper ];

    phases = [ "unpackPhase" "installPhase" ];
    unpackPhase = "dpkg-deb -x ${src} ./";

    installPhase = ''
      mkdir -p $out/bin
      substitute usr/bin/lightworks $out/bin/lightworks \
        --replace "/usr/lib/lightworks" "$out/lib/lightworks"
      chmod +x $out/bin/lightworks

      cp -r usr/lib $out

      # /usr/share/fonts is not normally searched
      # This adds it to lightworks' search path while keeping the default
      # using the FONTCONFIG_FILE env variable
      echo "<?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>
          <dir>/usr/share/fonts/truetype</dir>
          <include>/etc/fonts/fonts.conf</include>
      </fontconfig>" > $out/lib/lightworks/fonts.conf

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/lib/lightworks/ntcardvt

      wrapProgram $out/lib/lightworks/ntcardvt \
        --prefix LD_LIBRARY_PATH : ${fullPath}:$out/lib/lightworks \
        --set FONTCONFIG_FILE $out/lib/lightworks/fonts.conf
       
      cp -r usr/share $out/share
    '';

    dontPatchELF = true;

    meta = {
      description = "Professional Non-Linear Video Editor";
      homepage = "https://www.lwks.com/";
      license = stdenv.lib.licenses.unfree;
      maintainers = [ stdenv.lib.maintainers.antonxy ];
      platforms = [ "x86_64-linux" ];
    };
  };

# Lightworks expects some files in /usr/share/lightworks
in buildFHSUserEnv rec {
  name = lightworks.name;

  targetPkgs = pkgs: [
      lightworks
  ];

  runScript = "lightworks";
}
