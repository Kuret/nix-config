{ pkgs, ... }:

{
  programs.chromium.enable = true;
  programs.chromium.package = pkgs.brave;
  programs.chromium.extensions = [
    { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
    { id = "fnpkdafamnbjoldglihkjjdicofghccm"; } # GitHub Whitespace
    { id = "ldgfbffkinooeloadekpmfoklnobpien"; } # Raindrop
    { id = "ckejmhbmlajgoklhgbapkiccekfoccmk"; } # Mobile Simulator
    { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # Plasma Integration
  ];
}

