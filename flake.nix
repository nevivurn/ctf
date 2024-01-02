{
  inputs.nixpkgs.url = "github:nevivurn/nixpkgs/fix/sage-ecl";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default =
        let pythonPackages = ps: with ps; [ gmpy2 numpy pwntools pycryptodome z3 ]; in
        pkgs.mkShell {
          buildInputs = with pkgs; [ gmp ];
          packages = with pkgs; [
            (python3.withPackages pythonPackages)
            (sage.override { requireSageTests = false; extraPythonPackages = pythonPackages; })
            ghidra
            radare2
          ];
          env._JAVA_AWT_WM_NONREPARENTING = 1;
        };
    };
}
