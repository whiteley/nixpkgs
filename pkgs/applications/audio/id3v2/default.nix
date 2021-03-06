{stdenv, fetchurl, id3lib, groff, zlib}:

stdenv.mkDerivation rec {
  name = "id3v2-0.1.11";
  src = fetchurl {
    url = "mirror://sourceforge/id3v2/${name}.tar.gz";
    sha256 = "00r6f9yzmkrqa62dnkm8njg5cjzhmy0l17nj1ba15nrrm0mnand4";
  };

  patches = [ ./id3v2-0.1.11-track-bad-free.patch ];

  nativeBuildInputs = [ groff ];
  buildInputs = [ id3lib zlib ];

  configurePhase = ''
    export makeFlags=PREFIX=$out
  '';

  preInstall = ''
    mkdir -p $out/bin $out/man/man1
  '';

  meta = {
    description = "A command line editor for id3v2 tags";
    homepage = http://id3v2.sourceforge.net/;
    license = "GPLv2+";
  };
}
