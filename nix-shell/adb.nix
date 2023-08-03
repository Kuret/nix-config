with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    android-tools
    # clang
    # cmake
    # gcc
    # glibc
    # zlib
  ];
}
