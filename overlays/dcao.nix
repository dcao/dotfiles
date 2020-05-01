self: super:

{
  dcao-sh = super.callPackage ../pkgs/dcao-sh {};
  openmpt = super.callPackage ../pkgs/openmpt.nix {};
  world-wall = super.callPackage ../pkgs/world-wall {};
  catalina-wall = super.callPackage ../pkgs/catalina-wall {};
  olive-editor = super.libsForQt5.callPackage ../pkgs/olive-editor { 
    inherit (super.darwin.apple_sdk.frameworks) CoreFoundation;
  };
  imgur-sh = super.callPackage ../pkgs/imgur-sh.nix {};
  waybar = super.callPackage ../pkgs/waybar {};
  lightworks = super.callPackage ../pkgs/lightworks.nix {};
  ride = super.callPackage ../pkgs/ride.nix {};
  selenium-legacy = super.callPackage ../pkgs/selenium-legacy.nix {};

  nix-npm-install = super.writeScriptBin "nix-npm-install" ''
      #!/usr/bin/env bash
      tempdir="/tmp/nix-npm-install/$1"
      mkdir -p $tempdir
      pushd $tempdir
      # note the differences here:
      ${super.nodePackages.node2nix}/bin/node2nix --input <( echo "[\"$1\"]")
      nix-env --install --file .
      popd
    ''; 

  icuuc = self.icu;
  icui18n = self.icu;
  icudata = self.icu;
}
