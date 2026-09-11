{
  lib,
  stdenv,
  fetchurl,
  libsecret,
  autoPatchelfHook,
}:

stdenv.mkDerivation {
  pname = "proton-drive-cli";
  version = "0.8.0";

  src = fetchurl {
    url = "https://proton.me/download/drive/cli/0.8.0/linux-x64/proton-drive";
    hash = "sha512-z2HCaIxF4QVdit1iIdlHGlpbZL87zbhkYPXLGEFFlsxN8822YnyQl8lL7DKjyZFa2jIR7yrlvjPEbrvJlsyqKA==";
  };

  dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libsecret
  ];

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
