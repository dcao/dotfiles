{ stdenv, lib, buildGoModule, scdoc, libvterm, w3m, git, dante }:

let
  metadata = import ./metadata.nix;
in
buildGoModule rec {
  name = "aerc-${version}";
  version = "0.2.0";

  src = fetchGit metadata;
  # goPackagePath = "git.sr.ht/~sircmpwn/aerc";
  # goDeps = ./deps.nix;
  modSha256 = "1l9hjwxhva1imi6cp4qlgh6fdx1y6khhiwnac657j7xvh3fyvaq8";

  buildInputs = [
    scdoc libvterm w3m git dante
  ];

  postBuild = ''
    make doc aerc.conf
  '';

  installPhase = ''
    runHook preInstall
    >&2 ls -al
	mkdir -p $out/bin $out/share/man/man1 $out/share/man/man5 $out/share/man/man7 \
		$out/share/aerc $out/share/aerc/filters

	install -m755 $GOPATH/bin/aerc $out/bin/aerc
	install -m644 aerc.1 $out/share/man/man1/aerc.1
	install -m644 aerc-config.5 $out/share/man/man5/aerc-config.5
	install -m644 aerc-imap.5 $out/share/man/man5/aerc-imap.5
	install -m644 aerc-smtp.5 $out/share/man/man5/aerc-smtp.5
	install -m644 aerc-tutorial.7 $out/share/man/man7/aerc-tutorial.7
	install -m644 config/accounts.conf $out/share/aerc/accounts.conf
	install -m644 aerc.conf $out/share/aerc/aerc.conf
	install -m644 config/binds.conf $out/share/aerc/binds.conf
    install -m755 contrib/hldiff $out/share/aerc/filters/hldiff
	install -m755 contrib/html $out/share/aerc/filters/html
    install -m755 contrib/plaintext $out/share/aerc/filters/plaintext

    runHook postInstall
  '';

  dontPatchShebangs = true;

  meta = with stdenv.lib; {
    description = "The world's best email client";
    homepage    = https://git.sr.ht/~sircmpwn/aerc;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
