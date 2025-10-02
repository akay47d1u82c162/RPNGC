#!/usr/bin/env bash
set -o errexit
set -o pipefail

echo "[build] Installing deps..."
pip install -r requirements.txt

echo "[build] Collecting static..."
python manage.py collectstatic --noinput

if [ "${RENDER}" = "1" ]; then
  echo "[build] Render environment detected; checking DATABASE_URL..."
  if [ -z "${DATABASE_URL}" ]; then
    echo "[build] ERROR: DATABASE_URL is not set. Add it in Service → Environment." >&2
    exit 1
  fi
  python - <<'PY'
import os, urllib.parse
u=os.environ.get("DATABASE_URL","")
p=urllib.parse.urlparse(u) if u else None
print("[build] DB Host:", getattr(p,"hostname",None))
print("[build] DB Port:", getattr(p,"port",None))
if getattr(p,"hostname",None) in ("localhost","127.0.0.1","::1"):
    raise SystemExit("[build] ERROR: DATABASE_URL points to localhost; use your managed Postgres host.")
PY
fi

echo "[build] Running migrations..."
python manage.py migrate --noinput
echo "[build] Done."
