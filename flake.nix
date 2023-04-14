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
          pythonPackages = ps: with ps; [ pwntools pycryptodome z3 gmpy2 ];
        in
        pkgs.mkShell {
          _JAVA_AWT_WM_NONREPARENTING = 1;
          packages = with pkgs;
            [
              ghidra
              radare2
              (python3.withPackages pythonPackages)
              (sage.override { requireSageTests = false; extraPythonPackages = pythonPackages; })
            ];
        };
    };
}
