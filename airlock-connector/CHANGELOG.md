# Changelog

## 1.0.16

- Update connector image to `sha256:7b9bd3ba83b36bc1e3b5f8c3b97eca4e8cb6f919323cd3e398071c99b269583b`.

## 1.0.15

- Update connector image to `sha256:71b0ce459d97a416feda35a59502f8f45f542e47ec4c52b309ad7c0eb9e8fe3d`.

## 1.0.14

- Update connector image to `sha256:6dab808fcec193a2f8e5c3d253ac1b155bde8ca00dc4372041fc9399eba57ac2`.

## 1.0.13

- Update connector image to `sha256:0ecd22da519b57b47cb89c59df98f44b31697413f0930607bf4ccac7dfacbcdc`.

## 1.0.12

- Update connector image to `sha256:247a6dfd857b83236face283d28835465b18104b85a3b7fb97581f4bf5efd983`.

## 1.0.11

- Drop the custom AppArmor profile (kept as `apparmor.txt.disabled`); the
  Supervisor's auto-generated default profile applies instead. Enforce mode
  SIGSEGV-crashed the connector with no logged denial anywhere (a silent `deny`
  rule or the cx exec-transition into the child profile), and this add-on is
  already low-privilege (no privileged/host-network/caps/socket), so the default
  profile is the right trade. Revivable later by catching a fresh denial.

## 1.0.10

- **Revert AppArmor to complain mode** — enforce (v1.0.9) crashed the connector
  with SIGSEGV (exit 139); the profile blocks something it needs at startup.
  Complain restores a working tunnel (same connector image, proven in v1.0.8)
  while the denials are collected from the Host log to fix the rules before
  re-enforcing.

## 1.0.9

- Switch the AppArmor profile from complain to **enforce**: it now actively
  confines the connector + frpc (deny mount/ptrace/raw caps; writes limited to
  `/data`). If the add-on won't start, read the Host log (Settings → System → Logs
  → Source: Host, or `ha host logs`) for `apparmor="DENIED"` and add a rule — or
  re-add `complain` to both profiles while iterating.

## 1.0.8

- Roll to connector `sha256:2b4a5f49…`, which stamps its build (git sha) into
  the binary and reports it to the control plane. The Airlock admin dashboard
  now shows each tunnel's running version next to its status, with an
  up-to-date / out-of-date badge.

## 1.0.7

- Re-introduce the custom AppArmor profile in **complain mode**: it loads and
  logs what it would block but enforces nothing, so it can't break the add-on.
  Watch `journalctl -k | grep apparmor` (audit `ALLOWED`/`AVC`) during normal
  use; once nothing you rely on is flagged, drop `complain` from both profiles
  in `apparmor.txt` to enforce. (The earlier crash was the connector binary, not
  this profile — confirmed by the CI smoke test.)

## 1.0.6

- Roll forward to the rebuilt connector `sha256:33ccb7b7…`: built from a
  pinned Go toolchain with bounded deps (no `-u` churn), CVE-patched
  (x/crypto, x/net, go-jose) and CI smoke-tested on amd64 + arm64 — the
  build pipeline that auto-shipped the segfaulting `51671a99` is fixed.
- AppArmor profile stays disabled (`apparmor.txt.disabled`) — re-introduced
  separately once validated on a real install.

## 1.0.5

- Revert the connector image to the known-good `sha256:32ae0321…` build:
  the v1.0.3 auto-bump to `sha256:51671a99…` segfaulted on connect in
  production.
- Disable the custom AppArmor profile (renamed to `apparmor.txt.disabled`)
  until it's validated on a real install, and disable the daily auto-bump
  cron until the bump workflow smoke-tests the image, not just its signature.

## 1.0.4

- Add a custom AppArmor profile: confines the connector + frpc to `/data`
  and outbound TLS, denying mount/ptrace/raw capabilities.
- Mask the one-time enroll token in the add-on UI (schema `password`).
- connector-bump: cosign-verify the connector signature before repinning,
  so a repointed `:latest` can't be auto-released.

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
