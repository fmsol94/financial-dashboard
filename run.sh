#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/francisco/repositories/financial-dashboard"
URL="http://127.0.0.1:5500"

# pick a browser (Chromium preferred for app-window mode)
pick_browser() {
  for c in chromium chromium-browser google-chrome google-chrome-stable; do
    if command -v "$c" >/dev/null 2>&1; then
      echo "$c"; return
    fi
  done
  echo ""  # fallback will be xdg-open
}

start_server_if_needed() {
  if curl -fsS "$URL" >/dev/null 2>&1; then
    echo "Using existing server at $URL"
    echo ""  # no pid means we didn't start it
    return 0
  fi
  # start our venv + app in background
  source "$APP_DIR/.venv/bin/activate"
  python3 "$APP_DIR/app.py" &
  echo $!
}

wait_until_up() {
  local tries=60
  for _ in $(seq 1 $tries); do
    if curl -fsS "$URL" >/dev/null 2>&1; then return 0; fi
    sleep 0.25
  done
  echo "Server didn't come up at $URL" >&2
  exit 1
}

launch_browser_app_window() {
  local browser_bin
  browser_bin="$(pick_browser)"
  if [[ -z "$browser_bin" ]]; then
    # no chromium/chrome; fall back to default browser
    xdg-open "$URL" &
    echo $!
  else
    # open minimal chrome window with no tabs/toolbars
    "$browser_bin" --app="$URL" --new-window &
    echo $!
  fi
}

main() {
  FLASK_PID="$(start_server_if_needed || true)"
  wait_until_up
  BROWSER_PID="$(launch_browser_app_window)"

  # If we started the server, stop it when user closes the window
  if [[ -n "${FLASK_PID:-}" ]]; then
    wait "$BROWSER_PID" || true
    kill "$FLASK_PID" >/dev/null 2>&1 || true
  fi
}
main "$@"
