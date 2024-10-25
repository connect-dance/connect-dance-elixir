{
  description = "Connect.Dance Elixir Code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
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
          devShells = {
            default = pkgs.mkShell {
              packages = [
                pkgs.flyctl
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
