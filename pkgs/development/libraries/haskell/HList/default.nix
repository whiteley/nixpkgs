{ cabal, cmdargs, diffutils, doctest, filepath, hspec, lens, mtl
, syb
}:

cabal.mkDerivation (self: {
  pname = "HList";
  version = "0.3.1.0";
  sha256 = "1cq7l7cv62jf47s75ycsgxg75kkrgnnrpb6y22cskc97hkfsnjmk";
  buildDepends = [ mtl ];
  testDepends = [ cmdargs doctest filepath hspec lens mtl syb ];
  buildTools = [ diffutils ];
  doCheck = false;
  meta = {
    description = "Heterogeneous lists";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
