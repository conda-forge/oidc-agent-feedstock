#!/usr/bin/env bash
set -x

# The prompt templates ship pre-generated; make sure make never re-runs gen.sh,
# which needs bash >= 4 (macOS only has bash 3.2 in /bin/bash)
touch src/utils/prompting/templates/templates.h

declare -a ARGS
ARGS+=("CC=${CC}")
ARGS+=("LINKER=${CC}")
ARGS+=("PREFIX=${PREFIX}")
ARGS+=("BIN_PATH=${PREFIX}")
# Location of oidc-agent baked into oidc-agent-service, the desktop/Xsession
# files and the binaries (conda relocates it on install)
ARGS+=("BIN_AFTER_INST_PATH=${PREFIX}")
ARGS+=("PROMPT_BIN_PATH=${PREFIX}")
ARGS+=("LIB_PATH=${PREFIX}/lib/")
ARGS+=("LIBDEV_PATH=${PREFIX}/lib/")
ARGS+=("INCLUDE_PATH=${PREFIX}/include/")
ARGS+=("MAN_PATH=${PREFIX}/share/man")
ARGS+=("PROMPT_MAN_PATH=${PREFIX}/share/man")
ARGS+=("CONFIG_PATH=${PREFIX}/etc")
ARGS+=("BASH_COMPLETION_PATH=${PREFIX}/share/bash-completion/completions")
ARGS+=("DESKTOP_APPLICATION_PATH=${PREFIX}/share/applications")
ARGS+=("XSESSION_PATH=${PREFIX}/etc/X11")
# systemd tmpfiles.d snippet for /tmp, meaningless inside a conda environment
ARGS+=("TMPFILES_PATH=${SRC_DIR}/_tmpfiles.d")
# Use the vendored cJSON/list/mustach instead of probing the build machine
ARGS+=("USE_CJSON_SO=0")
ARGS+=("USE_LIST_SO=0")
ARGS+=("USE_MUSTACHE_SO=0")
# glib is still linked but unused since libsecret support was dropped in 5.0
ARGS+=("LGLIB=")
ARGS+=("SHELL=bash -x")

# Can't use multiple cores as the Makefile doesn't support it
make -j1 "${ARGS[@]}"
make install_lib "${ARGS[@]}"
make install "${ARGS[@]}"
