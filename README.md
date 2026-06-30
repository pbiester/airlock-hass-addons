# Airlock add-ons for Home Assistant

A [Home Assistant](https://www.home-assistant.io) add-on repository for
[Airlock](https://github.com/pbiester/airlock) — a self-hosted, hardened edge that
fronts your home apps with Google SSO and mutual-TLS (think self-hosted Cloudflare
Tunnel).

## Add this repository

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fpbiester%2Fairlock-hass-addons)

Or manually: **Settings → Add-ons → Add-on store → ⋮ (top-right) → Repositories**, then
add `https://github.com/pbiester/airlock-hass-addons`.

> Add-ons are called **Apps** in the Home Assistant UI since 2026.2 — same thing.

## Add-ons

### [Airlock Connector](./airlock-connector)

The home/LAN end of an Airlock tunnel. On first start it enrolls with a one-time token,
receives a client certificate from your Airlock control-plane CA, then publishes the
routes assigned to it over **outbound** mTLS on 443 — no inbound ports on your network.
See its [documentation](./airlock-connector/DOCS.md).
