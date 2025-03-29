{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };

      # https://github.com/NixOS/nixpkgs/pull/393730
      ergogen = pkgs.buildNpmPackage {
        pname = "ergogen";
        version = "4.1.0";
        forceGitDeps = true;
        src = pkgs.fetchFromGitHub {
          owner = "ergogen";
          repo = "ergogen";
          tag = "v4.1.0";
          hash = "sha256-Y4Ri5nLxbQ78LvyGARPxsvoZ9gSMxY14QuxZJg6Cu3Y=";
        };
        npmDepsHash = "sha256-BQbf/2lWLYnrSjwWjDo6QceFyR+J/vhDcVgCaytGfl0=";
        makeCacheWritable = true;
        dontNpmBuild = true;
        npmPackFlags = [ "--ignore-scripts" ];
        NODE_OPTIONS = "--openssl-legacy-provider";
      };
    in
    {
      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          packages = [ ergogen ];
        };
      };
    };
}
