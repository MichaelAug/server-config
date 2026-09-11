{
  lib,
  stdenv,
  fetchurl,
}:
# TODO: replace when proton-drive-cli is packaged in nixpkgs
stdenv.mkDerivation {
  pname = "proton-drive-cli";
  version = "0.8.0";

  src = fetchurl {
    url = "https://proton.me/download/drive/cli/0.8.0/linux-x64/proton-drive";
    hash = "sha512-z2HCaIxF4QVdit1iIdlHGlpbZL87zbhkYPXLGEFFlsxN8822YnyQl8lL7DKjyZFa2jIR7yrlvjPEbrvJlsyqKA==";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    install -Dm755 "$src" "$out/bin/proton-drive"
  '';

  meta = {
    description = "Proton Drive CLI";
    homepage = "https://proton.me/drive";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "proton-drive";
  };
}
