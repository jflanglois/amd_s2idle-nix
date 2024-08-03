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
        rev = "730b18d9f946a3fb2c7c4b10b19c7db1ef6f0927";
        hash = "sha256-87dWGeWOSOGfoeHEkOJP12Jv2f6+93iyist4vq2mTAY=";
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
