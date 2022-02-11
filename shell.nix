{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  latexPackage = pkgs.texlive.combine {
    inherit (texlive)
    # base packages
    scheme-small

    csquotes
    footnotebackref
    latexmk
    ly1
    mdframed
    needspace
    sourcecodepro
    sourcesanspro
    titling
    zref
    ;
  };

in

pkgs.mkShell {
  buildInputs = [
    latexPackage

    pkgs.gnumake
    pkgs.inotify-tools
    pkgs.pandoc
    pkgs.zathura
  ];
}
