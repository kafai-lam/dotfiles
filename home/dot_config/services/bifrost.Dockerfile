FROM maximhq/bifrost

USER root

ARG BUN_VERSION=bun-v1.3.14
ARG CONTEXT_MODE_VERSION=1.0.146
ENV BUN_INSTALL=/usr/local
ENV BUNX_CACHE_DIR=/opt/bunx-cache

RUN apk add --no-cache bash curl g++ libstdc++ make nodejs python3 unzip \
  && curl -fsSL https://bun.sh/install | BUN_INSTALL="${BUN_INSTALL}" bash -s -- "${BUN_VERSION}" \
  && ln -sf /usr/local/bin/bun /usr/local/bin/bunx \
  && bun --version \
  && bunx --version \
  && node --version \
  && mkdir -p "${BUNX_CACHE_DIR}" \
  && chown -R appuser:appuser "${BUNX_CACHE_DIR}"

USER appuser

RUN printf '%s\n' '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"docker-build","version":"0"}}}' \
  | TMPDIR="${BUNX_CACHE_DIR}" CONTEXT_MODE_DATA_DIR=/tmp/context-mode-build-data bunx --silent -y "context-mode@${CONTEXT_MODE_VERSION}" >/tmp/context-mode-handshake.json

USER appuser
