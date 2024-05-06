{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in pkgs.python3Packages.buildPythonApplication rec {
      pname = "amd_s2idle";
      version = "1.0";
      src = pkgs.fetchgit {
        url = "https://gitlab.freedesktop.org/drm/amd.git";
        rev = "74ac2fcc3ce886fcbf9b417cc8a139d6d03eb67e";
        hash = "sha256-wIjk4JdiI30P/Djxi++ow3I2/utm+WcUWkmmbM+h2BA=";
      };
      installPhase = ''install -Dm755 scripts/amd_s2idle.py $out/bin/amd_s2idle'';
      format = "other";
      dependencies = with pkgs.python3Packages; [
        packaging
        pyudev
      ];
      preFixup = ''
        makeWrapperArgs+=(--prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.acpica-tools
        ]})
      '';
    };
  };
}
