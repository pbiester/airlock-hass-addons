# Changelog

## 1.0.3

- Update connector image to `sha256:51671a99f4320e557848f60dd12b509dc169682847cc4b5105c8d8d51e895c01`.

## 1.0.2

- Pin the connector image by digest (reproducible builds).
- Add a `connector-bump` workflow that repins and cuts a new release when the connector
  image changes, so HA flags an update for installed add-ons.

## 1.0.1

- Drop host networking: the connector reaches Home Assistant (`homeassistant:8123`),
  other add-ons, and LAN devices over the Supervisor's internal network instead. More
  isolated, no host-port conflicts.

## 1.0.0

- Initial release: packages the Airlock connector as a Home Assistant add-on.
- Enrollment, control-plane URL and renewal/poll tuning exposed as add-on options.
- Persists the issued key/cert in the add-on's `/data` (one-time token).
- Host networking; `amd64` + `aarch64`.
