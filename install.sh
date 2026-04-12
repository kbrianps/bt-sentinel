#!/bin/bash

set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
SERVICE_DIR="${HOME}/.config/systemd/user"

echo "Installing bt-sentinel..."

mkdir -p "$INSTALL_DIR" "$SERVICE_DIR"

cp bt-sentinel "$INSTALL_DIR/bt-sentinel"
chmod +x "$INSTALL_DIR/bt-sentinel"

cp bt-sentinel.service "$SERVICE_DIR/bt-sentinel.service"

systemctl --user daemon-reload
systemctl --user enable --now bt-sentinel.service

echo "Done. bt-sentinel is running."
echo "Check status: systemctl --user status bt-sentinel"
echo "View logs:    journalctl --user -u bt-sentinel -f"
