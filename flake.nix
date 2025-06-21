{
    description = "XMonad";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    outputs = {
        defaultPackage.x86_64-linux = 
            with import nixpkgs { system = "x86_64-linux"; };
            stdenv.mkDerivation {
                pname = "xmonad";
                version = "0.1";

                src = ./.;

                # buildInputs = [ xmonad xmonad-contrib ];
                # nativeBuildInputs = [ cabal-install ];

                installPhase = ''
                    make install
                '';
            };
    }
}
