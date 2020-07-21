{ stdenv, fetchurl, cln, gmp, swig, pkgconfig
, readline, libantlr3c, boost, jdk
, python3, antlr3_4, unzip, bash, cmake, git
, python37Packages
}:

stdenv.mkDerivation rec {
  pname = "cvc4";
  version = "1.8";

  src = fetchurl {
    url = "https://github.com/CVC4/CVC4/archive/545bdeebf38e7212dc161567ec16ddc6bd36d708.zip";
    sha256 = "0h0mik5yx38jmw8qgzy5hbxcl4b3hwcj16iv6yf3chwfgdm6912x";
  };

  nativeBuildInputs = [ pkgconfig unzip ];
  buildInputs = [ gmp cln readline swig libantlr3c antlr3_4 boost jdk python3 unzip bash cmake git python37Packages.toml ];
  configureFlags = [
    "--enable-language-bindings=c,c++,java"
    "--enable-gpl"
    "--with-cln"
    "--with-readline"
    "--with-boost=${boost.dev}"
  ];

  preConfigure = ''
  '';

  configurePhase = ''
    patchShebangs ./configure.sh
    patchShebangs ./src/mksubdirs
    patchShebangs ./src/theory/mktheorytraits
    patchShebangs ./src/theory/mkrewriter
    patchShebangs ./src/base/mktags
    patchShebangs ./src/base/mktagheaders
    patchShebangs ./src/expr/mkexpr
    patchShebangs ./src/expr/mkkind
    patchShebangs ./src/expr/mkmetakind
    ./configure.sh
  '';

  buildPhase = ''
    cd build
    make
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A high-performance theorem prover and SMT solver";
    homepage    = "http://cvc4.cs.stanford.edu/web/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ vbgl thoughtpolice gebner ];
  };
}