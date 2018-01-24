let
  ghc-options = [
    # Enable threading.
    "-threaded" "-rtsopts" "-with-rtsopts=-N"
  ];

  pkgs = import <nixpkgs> { };

in
  { task5 = pkgs.haskellPackages.callPackage ./default.nix { };
  }
