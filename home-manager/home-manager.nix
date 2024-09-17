let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz"; #<-- target similar version than your Nixpkgs version (don't forget to update when you update)
in
{
  imports = [
    (import "${home-manager}/nixos")
    #users accounts
    ./users/main.nix
    ./users/games.nix
  ];
}
