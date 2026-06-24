#!/usr/bin/env bash
set -euo pipefail

FLUTTER_DIR="/tmp/flutter"

if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
fi

"${FLUTTER_DIR}/bin/flutter" config --enable-web
"${FLUTTER_DIR}/bin/flutter" pub get
