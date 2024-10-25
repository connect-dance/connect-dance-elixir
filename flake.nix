{
  description = "Connect.Dance Elixir Code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.process-compose-flake.flakeModule
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          erlangVersion = "erlang_27";
          elixirVersion = "elixir_1_17";

          erlang = pkgs.beam.interpreters.${erlangVersion};
          elixir = pkgs.beam.packages.${erlangVersion}.${elixirVersion};
          hex = pkgs.beam.packages.${erlangVersion}.hex;
        in
        {
          process-compose."connect-dance-dev" =
            { config, ... }:
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];
              services.postgres."pg1" = {
                enable = true;
                dataDir = "./.dev-data";
                package = pkgs.postgresql_16;
                extensions = extensions: [
                  extensions.postgis
                ];
                initialDatabases = [ { name = "connect_dance_dev"; } ];
                initialScript.before = ''
                  CREATE EXTENSION IF NOT EXISTS postgis;
                  CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' SUPERUSER;
                '';
              };
            };
          devShells = {
            default = pkgs.mkShell {
              packages = [
                pkgs.flyctl
                pkgs.just
                erlang
                elixir
                hex
                pkgs.nodejs_22
                pkgs.elixir-ls
                pkgs.inotify-tools
              ];
              shellHook = ''
                # this allows mix to work on the local directory
                mkdir -p .nix-mix .nix-hex
                export MIX_HOME=$PWD/.nix-mix
                export HEX_HOME=$PWD/.nix-hex
                # make hex from Nixpkgs available
                # `mix local.hex` will install hex into MIX_HOME and should take precedence
                export MIX_PATH="${hex}/lib/erlang/lib/hex/ebin"
                export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
                export LANG=C.UTF-8
                # keep your shell history in iex
                export ERL_AFLAGS="-kernel shell_history enabled"
              '';
            };
          };
        };
    };
}
