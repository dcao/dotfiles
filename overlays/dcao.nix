self: super:

{
  openmpt = super.callPackage ../pkgs/openmpt.nix {};
  world-wall = super.callPackage ../pkgs/world-wall {};
  catalina-wall = super.callPackage ../pkgs/catalina-wall {};
  olive-editor = super.libsForQt5.callPackage ../pkgs/olive-editor { 
    inherit (super.darwin.apple_sdk.frameworks) CoreFoundation;
  };
  imgur-sh = super.callPackage ../pkgs/imgur-sh.nix {};
  waybar = super.callPackage ../pkgs/waybar {};
  lightworks = super.callPackage ../pkgs/lightworks.nix {};

  icuuc = self.icu;
  icui18n = self.icu;
  icudata = self.icu;
}
