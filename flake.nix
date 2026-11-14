{
  description = "Zigduck - GNOME Shell extension.";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      version = "0.1.2";
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.runCommand "zigduck-${version}" {
            inherit version;
          } ''
            mkdir -p "$out/share/gnome-shell/extensions/zigduck@quackhack-mcblindy.com"
            cp -r ${builtins.path {
              path = ./.;
              name = "zigduck-source";
            }}/zigduck@quackhack-mcblindy.com/. \
              "$out/share/gnome-shell/extensions/zigduck@quackhack-mcblindy.com/"
          '';
        });
        
    };}
