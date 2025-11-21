{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      self,
      nixpkgs,
      mnw,
      nur,
    }@inputs:
    let
      lib = nixpkgs.lib;
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems =
        function:
        lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                nur.overlays.default
              ];
            };
          in
          function pkgs
        );
    in
    {
      packages = forAllSystems (pkgs: {
        default = import ./default.nix {
          inherit
            inputs
            pkgs
            mnw
            nur
            ;
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = lib.singleton self.packages.${pkgs.stdenv.hostPlatform.system}.default.devMode;
        };
      });
    };
}
