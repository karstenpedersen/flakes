{
  description = "Java development environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      javaVersion = 21;
      overlays = [
        (final: prev: rec {
          jdk = prev."jdk${toString javaVersion}";
          gradle = prev.gradle.override { java = jdk; };
          maven = prev.maven.override { inherit jdk; };
        })
      ];
      pkgs = import nixpkgs { inherit system; };
    in
    rec {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          jdk
          gradle
          maven
        ];
      };
    }
  );
}
