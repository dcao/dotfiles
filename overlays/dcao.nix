self: super:

{
  openmpt = super.callPackage ../pkgs/openmpt.nix {};
  world-wall = super.callPackage ../pkgs/world-wall {};
  olive-editor = super.libsForQt5.callPackage ../pkgs/olive-editor.nix { 
    inherit (super.darwin.apple_sdk.frameworks) CoreFoundation;
  };
  imgur-sh = super.callPackage ../pkgs/imgur-sh.nix {};
}
