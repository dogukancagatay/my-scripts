#!/usr/bin/env bash

declare -A PLUGINS

PLUGINS["github.com/hashicorp/qemu"]="1.0.2"
# PLUGINS["github.com/hashicorp/qemu"]="1.0.2"
# PLUGINS["github.com/hashicorp/qemu"]="1.0.2"

PACKER_PLUGIN_PATH="$HOME/.packer.d/plugins"
GITHUB_PROXY_PREFIX="https://" # http://nexus/repository/
OS="windows"                   # darwin, linux

function download_plugin() {
    PLUGIN_PATH="$1"
    PLUGIN_VERSION="$2"

    PLUGIN_DOWNLOAD_URL="${GITHUB_PROXY_PREFIX}$(dirname ${PLUGIN_PATH})/packer-plugin-$(basename ${PLUGIN_PATH})/releases/download/v${PLUGIN_VERSION}/packer-plugin-$(basename ${PLUGIN_PATH})_v${PLUGIN_VERSION}_x5.0_${OS}_amd64.zip"
    PLUGIN_CHECKSUM_DOWNLOAD_URL="${GITHUB_PROXY_PREFIX}$(dirname ${PLUGIN_PATH})/packer-plugin-$(basename ${PLUGIN_PATH})/releases/download/v${PLUGIN_VERSION}/packer-plugin-$(basename ${PLUGIN_PATH})_v${PLUGIN_VERSION}_SHA256SUMS"

    PLUGIN_DOWNLOAD_FILENAME="$(basename ${PLUGIN_DOWNLOAD_URL})"
    PLUGIN_DOWNLOAD_CHECKSUM_FILENAME="$(basename ${PLUGIN_CHECKSUM_DOWNLOAD_URL})"

    mkdir -p "${PACKER_PLUGIN_PATH}/${PLUGIN_PATH}"
    echo "Downloading: ${PLUGIN_DOWNLOAD_URL}"
    curl -fsSL -o "${PACKER_PLUGIN_PATH}/${PLUGIN_PATH}/${PLUGIN_DOWNLOAD_FILENAME}" "${PLUGIN_DOWNLOAD_URL}"
    echo "Downloading: ${PLUGIN_CHECKSUM_DOWNLOAD_URL}"
    curl -fsSL -o "${PACKER_PLUGIN_PATH}/${PLUGIN_PATH}/${PLUGIN_DOWNLOAD_CHECKSUM_FILENAME}" "${PLUGIN_CHECKSUM_DOWNLOAD_URL}"
    cd "${PACKER_PLUGIN_PATH}/${PLUGIN_PATH}"
    sha256sum -c --ignore-missing "${PLUGIN_DOWNLOAD_CHECKSUM_FILENAME}"
    unzip "${PLUGIN_DOWNLOAD_FILENAME}"

    rm -rf "${PLUGIN_DOWNLOAD_FILENAME}" "${PLUGIN_DOWNLOAD_CHECKSUM_FILENAME}"
    PLUGIN_EXEC_FILENAME="$(ls -1)"
    sha256sum "${PLUGIN_EXEC_FILENAME}" | awk '{print $1}' >"${PLUGIN_EXEC_FILENAME}_SHA256SUM"
}

for PLUGIN in "${!PLUGINS[@]}"; do
    echo "$PLUGIN -> ${PLUGINS[$PLUGIN]}"
    download_plugin "$PLUGIN" "${PLUGINS[$PLUGIN]}"
done
