#!/bin/bash

set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
SERVICE_DIR="${HOME}/.config/systemd/user"

echo "Uninstalling bt-sentinel..."

systemctl --user stop bt-sentinel.service 2>/dev/null || true
systemctl --user disable bt-sentinel.service 2>/dev/null || true

rm -f "$INSTALL_DIR/bt-sentinel"
rm -f "$SERVICE_DIR/bt-sentinel.service"

systemctl --user daemon-reload

echo "Done. bt-sentinel has been removed."
