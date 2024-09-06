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
        rev = "69db67c36fc8bf6d881ab9e0838124f532a4a64d";
        hash = "sha256-9vwDX4q/8BKV1scPkB2o2jchMMvmOT3DJ/c/N6Qy4ck=";
      };
      installPhase = ''install -Dm755 scripts/amd_s2idle.py $out/bin/amd_s2idle'';
      format = "other";
      dependencies = with pkgs.python3Packages; [
        distro
        packaging
        pyudev
        systemd
      ];
      preFixup = ''
        makeWrapperArgs+=(--prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.acpica-tools
        ]})
      '';
    };
  };
}
