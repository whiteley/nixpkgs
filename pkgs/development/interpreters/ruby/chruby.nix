{ stdenv, fetchurl, ... }:

stdenv.mkDerivation rec {
  version = "0.3.8";
  name = "chruby-${version}";

  src = fetchurl {
    url = "${meta.homepage}/archive/v${version}.tar.gz";
    sha256 = "d980872cf2cd047bc9dba78c4b72684c046e246c0fca5ea6509cae7b1ada63be";
  };

  configurePhase = ''
    makeFlags="PREFIX=$out"
  '';

  meta = {
    homepage = https://github.com/postmodern/chruby;
    description = "Changes the current Ruby";
    license = "MIT";
  };
}
