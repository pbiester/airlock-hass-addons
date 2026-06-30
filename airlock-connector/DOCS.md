# Home Assistant Add-on: Airlock Connector

The home/LAN end of an [Airlock](https://github.com/pbiester/airlock) tunnel — the
self-hosted equivalent of Cloudflare Tunnel. It exposes Home Assistant (and any other
app on your network) through your hardened Airlock edge, which fronts everything with
Google SSO and mutual-TLS. **No inbound ports are opened on your network**: the
connector only makes outbound TLS connections to your Airlock host on 443.

## How it works

On first start the connector enrolls with a **one-time token** (printed by the Airlock
dashboard when you add a connector) and receives a client certificate from the
control-plane CA. It then dials the edge over mTLS, publishes the routes assigned to it,
and polls the control plane so route changes apply without restarting the add-on. It
renews its own certificate before expiry. The issued key/cert live in the add-on's
persistent `/data`, so the token is used exactly once.

## Installation

1. Add this repository to Home Assistant: **Settings → Add-ons → Add-on store → ⋮
   (top-right) → Repositories**, then add
   `https://github.com/pbiester/airlock-hass-addons`.
2. Install **Airlock Connector** from the store.
3. Open the **Configuration** tab and set the options below.
4. Start the add-on and watch the **Log** tab.

## Configuration

| Option | Required | Default | Description |
| --- | --- | --- | --- |
| `server` | yes | — | Your control-plane connect host, e.g. `connect.apps.example.com`. |
| `enroll_token` | first run | — | One-time enrollment token from the dashboard. Only needed until a certificate exists in `/data`; you can clear it afterwards. |
| `poll_seconds` | no | `30` | Seconds between control-plane config polls. |
| `renew_before_days` | no | `21` | Renew the client certificate this many days before expiry. |

### Adding a connector / getting the token

In the Airlock dashboard, add a connector — it shows a one-time enrollment token (and a
`docker run` line; you only need the token here). Paste the token into `enroll_token`,
set `server` to your `connect.<base>` host, and start the add-on.

## Networking

The add-on runs on the Supervisor's internal network (no host networking needed), so it
stays isolated and won't conflict with host ports. From there it reaches your targets by
name or IP — set each route's target in the **Airlock dashboard**:

- **Home Assistant itself** → `homeassistant:8123`.
- **Another add-on** → its hostname and port (e.g. `core-mosquitto:1883`).
- **A LAN device** → its IP/hostname and port (e.g. `192.168.1.50:80`); egress to the
  LAN and to the Airlock edge is NAT'd, so no host networking is required.

A route's target only needs to be reachable *from the add-on container*. Routes,
hostnames and auth modes (public / SSO / mTLS) are all declared in the Airlock
dashboard — there is nothing to configure here beyond enrollment.

## Re-enrolling

The issued certificate is stored in the add-on's persistent `/data`. To enroll from
scratch (e.g. after revoking the connector in the dashboard), uninstall the add-on
(which clears `/data`), reinstall it, and start with a fresh `enroll_token`.

## Supported architectures

`amd64` and `aarch64` (Home Assistant Green/Yellow, Raspberry Pi 4/5 64-bit, x86-64
hosts). The connector image is not published for 32-bit `armv7`/`armhf`.

## Support

Issues and source: <https://github.com/pbiester/airlock-hass-addons>.
