{ mkDerivation, base, bytestring, directory, stdenv, text, turtle
}:
mkDerivation {
  pname = "task5";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base bytestring directory text turtle
  ];
  license = stdenv.lib.licenses.mit;
}
