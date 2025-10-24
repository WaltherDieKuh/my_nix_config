{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  coreutils,
  gnused,
  bash,
  alsa-lib,
  jack2,
  gst_all_1,
  libarchive,
  cups,
  libGL,
  libGLU,
  xorg,
  libxcb,
  libxkbcommon,
  udev,
  zlib,
  lz4,
  libtiff,
}: let
  pname = "magicq";
  version = "1.9.7.3";
  _pkgver = lib.replaceStrings ["."] ["_"] version;
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "http://files.magicq.co.uk/v${_pkgver}/magicq_ubuntu_v${_pkgver}.deb";
      sha256 = "16c552b7d8888702ffc08d97626289ac0efcd34c05436a89fee1776db30bc344";
    };

    dontUnpack = true;
    dontStrip = true;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      gnused
    ];

    # Let autoPatchelf also search the package's own lib dir (for our libtiff shim)
    autoPatchelfLibs = [
      "${placeholder "out"}/opt/magicq/lib"
    ];

    # Runtime libs so autoPatchelf can resolve dependencies
    buildInputs = [
      alsa-lib
      jack2

      # GStreamer
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad

      # Archive deps
      libarchive
      lz4
      zlib

      # Graphics/OpenGL
      libGL
      libGLU

      # X11/XCB stack
      xorg.libX11
      libxcb
      xorg.xcbutilwm # libxcb-icccm.so.4
      xorg.xcbutilimage # libxcb-image.so.0
      xorg.xcbutilkeysyms # libxcb-keysyms.so.1
      xorg.xcbutilrenderutil # libxcb-render-util.so.0
      libxkbcommon # libxkbcommon{,-x11}.so

      # Printing
      cups

      # Image formats
      libtiff

      # Udev
      udev
    ];

    installPhase = ''
          runHook preInstall

          mkdir -p "$out"
          ${dpkg}/bin/dpkg-deb -x "$src" "$out"

          # Prefer system libraries over bundled ones
          rm -f "$out/opt/magicq/lib/libstdc++.so.6"
          rm -f "$out/opt/magicq/lib/libjack.so.0"

          # libtiff5 shim for Qt's libqtiff plugin
          mkdir -p "$out/opt/magicq/lib"
          ln -s ${lib.getLib libtiff}/lib/libtiff.so.6 "$out/opt/magicq/lib/libtiff.so.5" || true

          # License
          mkdir -p "$out/share/licenses/${pname}"
          ln -s "$out/opt/magicq/License_Conditions.txt" "$out/share/licenses/${pname}/LICENSE"

          # Wrapper generator
          mkWrapper() {
            local name="$1"
            local target="$2"

            mkdir -p "$out/bin"
            cat > "$out/bin/$name" <<'EOF'
      #!/usr/bin/env bash
      set -euo pipefail

      # Resolve store root from this script path (works via profile symlinks)
      self="$(${coreutils}/bin/readlink -f "$0")"
      bindir="$(${coreutils}/bin/dirname "$self")"
      outRoot="$(${coreutils}/bin/dirname "$bindir")"
      src="$outRoot/opt/magicq"

      # Determine per-user writable data directory without brace-style default expansion
      xdg="$(${coreutils}/bin/printenv XDG_DATA_HOME 2>/dev/null || true)"
      if [ -z "$xdg" ]; then
        xdg="$HOME/.local/share"
      fi
      MAGICQ_DATA_DIR="$xdg/magicq"

      # Prepare data dir on first run
      ${coreutils}/bin/mkdir -p "$MAGICQ_DATA_DIR"
      if [ ! -e "$MAGICQ_DATA_DIR/.populated" ]; then
        ${coreutils}/bin/cp -a "$src/." "$MAGICQ_DATA_DIR"/
        ${coreutils}/bin/chmod -R u+w "$MAGICQ_DATA_DIR"
        ${coreutils}/bin/touch "$MAGICQ_DATA_DIR/.populated"
      fi

      # Always ensure scripts/binaries are executable (handles upgrades and older bad copies)
      ${coreutils}/bin/chmod +x "$MAGICQ_DATA_DIR"/runmagicq.sh "$MAGICQ_DATA_DIR"/runmagichd.sh "$MAGICQ_DATA_DIR"/runmagicvis.sh || true
      if [ -d "$MAGICQ_DATA_DIR/bin" ]; then
        ${coreutils}/bin/chmod -R a+rx "$MAGICQ_DATA_DIR/bin" || true
      fi

      cd "$MAGICQ_DATA_DIR"
      # Use bash to run the vendor script to avoid EACCES on the script itself
      exec ${bash}/bin/bash "$MAGICQ_DATA_DIR/__TARGET__" "$@"
      EOF
            chmod +x "$out/bin/$name"
            ${gnused}/bin/sed -i "s|__TARGET__|$target|g" "$out/bin/$name"
          }

          mkWrapper magicq     runmagicq.sh
          mkWrapper magichd    runmagichd.sh
          mkWrapper magicvis   runmagicvis.sh

          runHook postInstall
    '';

    meta = with lib; {
      description = "Lighting control software from ChamSys";
      homepage = "https://chamsyslighting.com/products/magicq";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
    };
  }
