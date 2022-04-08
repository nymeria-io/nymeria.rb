{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "nymeria.rb";

  nativeBuildInputs = with pkgs; [
    ruby
  ];
}
