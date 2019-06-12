{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols, sway, wlroots
, libpulseaudio, libinput, libnl, gtkmm3
, fmt, jsoncpp, libdbusmenu-gtk3
, glib
, git
, mpd_clientlib
, spdlog
}:

let
  metadata = import ./metadata.nix;
  metadataSpdlog = import ./metadataSpdlog.nix;
  mySpdlog = spdlog.overrideAttrs (old: rec {
    name = "spdlog-1.3.1";
    src = fetchFromGitHub metadataSpdlog;
    cmakeFlags = [
      "-DSPDLOG_BUILD_EXAMPLES=OFF"
      "-DSPDLOG_BUILD_BENCH=OFF"
    ];
  });
in
stdenv.mkDerivation rec {
  name = "waybar-${version}";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = version;
    sha256 = metadata.sha256;
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    wayland wayland-protocols sway wlroots
    libpulseaudio libinput libnl gtkmm3
    git fmt jsoncpp libdbusmenu-gtk3
    glib
    mpd_clientlib mySpdlog
  ];
  mesonFlags = [
    "-Dauto_features=enabled"
    "-Dpulseaudio=enabled"
    "-Dout=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Highly customizable Wayland Polybar like bar for Sway and Wlroots based compositors.";
    homepage    = https://github.com/Alexays/Waybar;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
