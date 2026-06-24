#!/usr/bin/env bash
set -euo pipefail

FLUTTER_DIR="/tmp/flutter"

if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  bash ./scripts/vercel-install.sh
fi

"${FLUTTER_DIR}/bin/flutter" config --enable-web
"${FLUTTER_DIR}/bin/flutter" pub get
"${FLUTTER_DIR}/bin/flutter" build web --release \
  --dart-define=MATEYA_API_BASE_URL="${MATEYA_API_BASE_URL}" \
  --dart-define=NAVER_MAP_CLIENT_ID="${NAVER_MAP_CLIENT_ID}" \
  --dart-define=MATEYA_CUSTOMER_SUPPORT_URL="${MATEYA_CUSTOMER_SUPPORT_URL}" \
  --dart-define=MATEYA_PRIVACY_POLICY_URL="${MATEYA_PRIVACY_POLICY_URL}"
