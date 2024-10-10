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
        rev = "b5d9b83d756608423bf3d3cecf4ad24eb0951e2a";
        hash = "sha256-NnTY7u7zE7lVX0QAkywgnjhbLDinmNWYKGDTRiN7B/A=";
      };
      installPhase = ''
        install -Dm755 scripts/amd_s2idle.py $out/bin/amd_s2idle
      '';
      format = "other";
      dependencies = with pkgs.python3Packages; [
        distro
        packaging
        pygobject3
        pyudev
        systemd
      ];
      buildInputs = [
        pkgs.fwupd
        pkgs.gtk3
        pkgs.json-glib
      ];
      nativeBuildInputs = [
        pkgs.gobject-introspection
        pkgs.wrapGAppsHook
      ];
      preFixup = ''
        makeWrapperArgs+=(--prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.acpica-tools
        ]})
      '';
    };
  };
}
