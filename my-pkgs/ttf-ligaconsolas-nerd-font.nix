{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "ttf-ligaconsolas-nerd-font";
  version = "1";

  src = fetchFromGitHub {
    owner = "Dosx001";
    repo = "ttf-ligaconsolas-nerd-font";
    rev = "ebef23744a37f0b7f2e5f5ee0668a3518f9a965a";
    sha256 = "BRRODstLgL0pNmLbP3y+2k3JT7jWAFTNtgsQ+tDRhkQ=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
    # find . -name '*.ttf' -exec install -Dt $out/share/fonts/truetype {} \;
  '';

  meta = {
    description = "Consolas font with ligatures and glyphs";
    homepage = "https://github.com/Dosx001/ttf-ligaconsolas-nerd-font";
    license = lib.licenses.unfree;
  };
}
