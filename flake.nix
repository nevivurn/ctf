{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default =
        let
          pythonPackages = ps: with ps; [ pwntools pycryptodome ];
        in
        pkgs.mkShell {
          packages = with pkgs; [
            (python3.withPackages pythonPackages)
            (sage.override { requireSageTests = false; extraPythonPackages = pythonPackages; })
          ];
        };
    };
}
