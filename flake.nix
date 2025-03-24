{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in pkgs.python3Packages.buildPythonApplication rec {
      pname = "amd_s2idle";
      version = "1.0";
      src = pkgs.fetchgit {
        url = "git://git.kernel.org/pub/scm/linux/kernel/git/superm1/amd-debug-tools.git";
        rev = "71882dd21a9b037c6cb99de56db6655d54f72c18";
        hash = "sha256-DjqoCZn0I2Teoa7k4ogBNPuW9cj4+8u2XZLQmIdKEtE=";
      };
      installPhase = ''
        install -Dm755 amd_s2idle.py $out/bin/amd_s2idle
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
