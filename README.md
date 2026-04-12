# bt-sentinel

Bluetooth audio watchdog for Linux. Monitors and automatically fixes common Bluetooth headphone issues on PipeWire/BlueZ systems.

## Problems it solves

1. **Silent headphones** - Headphones are connected but no audio comes through. Caused by PipeWire node entering error state or WirePlumber running out of audio buffers. Usually requires manually disconnecting and reconnecting.

2. **Failed reconnection after device switch** - After using headphones on another device (phone, Windows, etc.), Linux fails to reconnect even after the headphones are available again.

## Requirements

- Linux with PipeWire + WirePlumber (Ubuntu 22.04+, Fedora 34+, etc.)
- BlueZ (`bluetoothctl`)
- PipeWire tools (`wpctl`, `pw-cli`)
- systemd (for the journal-based detection and service)

## Install

```bash
git clone https://github.com/YOUR_USER/bt-sentinel.git
cd bt-sentinel
chmod +x install.sh
./install.sh
```

## Uninstall

```bash
./uninstall.sh
```

## Usage

Run once (check and fix now):

```bash
bt-sentinel
```

Run as daemon:

```bash
bt-sentinel -d
```

With verbose logging:

```bash
bt-sentinel -dv
```

Custom polling interval:

```bash
bt-sentinel -d -i 10
```

## How it works

In daemon mode, bt-sentinel polls every 5 seconds (configurable) and:

1. Checks all connected Bluetooth audio devices for:
   - PipeWire node in `error` state
   - WirePlumber `out of buffers` messages in journal
   - PipeWire error events related to the Bluetooth node
2. If any issue is detected, performs a disconnect/reconnect cycle
3. Checks all paired + trusted audio devices that are not connected and attempts to reconnect

A per-device cooldown (default: 30s) prevents reconnection loops.

## Configuration

All configuration is done via environment variables:

| Variable | Default | Description |
|---|---|---|
| `BT_SENTINEL_INTERVAL` | `5` | Polling interval in seconds |
| `BT_SENTINEL_RECONNECT_DELAY` | `2` | Delay between disconnect and connect |
| `BT_SENTINEL_MAX_RETRIES` | `3` | Max reconnection attempts |
| `BT_SENTINEL_OOB_THRESHOLD` | `3` | Out-of-buffers count to trigger fix |
| `BT_SENTINEL_COOLDOWN` | `30` | Seconds between reconnects per device |

To customize, edit the systemd service:

```bash
systemctl --user edit bt-sentinel.service
```

Add:

```ini
[Service]
Environment="BT_SENTINEL_INTERVAL=10"
Environment="BT_SENTINEL_COOLDOWN=60"
```

## Service management

```bash
systemctl --user status bt-sentinel
systemctl --user restart bt-sentinel
journalctl --user -u bt-sentinel -f
```

## License

MIT
