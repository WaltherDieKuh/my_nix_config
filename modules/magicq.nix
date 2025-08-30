{ config, pkgs, ... }:

let
  magicqFHS = pkgs.buildFHSEnv {
    name = "magicq";
    targetPkgs = pkgs: [
      pkgs.dpkg
      pkgs.libarchive
      pkgs.zlib
      pkgs.libGL
      pkgs.libGLU
      pkgs.libusb-compat-0_1
      pkgs.libusb1
      pkgs.qt5.qtbase
      pkgs.qt5.qtwayland
      pkgs.qt5.qtmultimedia
      pkgs.ffmpeg_4
      pkgs.acl
      pkgs.zstd
      pkgs.lz4
      pkgs.bzip2
      pkgs.stdenv.cc
      # ggf. weitere Libraries, falls weitere Fehler auftreten
    ];
    runScript = "bash";
  };
in
{
  home.packages = [ magicqFHS ];
}