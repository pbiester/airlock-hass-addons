ARG BUILD_FROM

# Lift the two static binaries out of the published Airlock connector image
# (multi-arch amd64+arm64, cosign-signed + Trivy-scanned by Airlock CI). A native
# per-arch build pulls the matching platform automatically. Pinned by digest for
# reproducible builds; the connector-bump workflow repins + releases on updates.
FROM ghcr.io/pbiester/airlock-connector@sha256:32ae0321b366f500a36d4266514dba989c5da0ef525826558b6ff8b0b9d5f7b3 AS connector

FROM ${BUILD_FROM}

# Both are CGO-free static Go binaries, so they run unchanged on the Alpine base.
COPY --from=connector /usr/local/bin/airlock-connector /usr/local/bin/airlock-connector
COPY --from=connector /usr/local/bin/frpc /usr/local/bin/frpc

COPY run.sh /
RUN chmod a+x /run.sh

# s6-overlay (from the base image) is PID 1 — see config.yaml `init: false`. run.sh is
# the long-running service that maps add-on options to the connector's environment.
CMD [ "/run.sh" ]
