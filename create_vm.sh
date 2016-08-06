#!/usr/bin/env bash

set -e
[[ "${1}" = '--debug' ]] && set -x

GUEST='[127.0.0.1]:2222'
SHARE_DIR="share"
TMP_DIR="${SHARE_DIR}/tmp"
DISABLE_SYNC_FLAG="${TMP_DIR}/disable_synced_folder"
DOCKER_TMP_DIR="${TMP_DIR}/docker"

if [[ -f 'config.yml' ]] && [[ "$(grep -ce '^[^#]\+_proxy:' config.yml)" -gt 0 ]]; then
  if [[ $(vagrant plugin list | grep -ce '^vagrant-proxyconf ') -eq 0 ]]; then
    vagrant plugin install vagrant-proxyconf
  else
    vagrant plugin update vagrant-proxyconf
  fi
fi

[[ "$(grep -cF ${GUEST} ~/.ssh/known_hosts)" -eq 0 ]] || ssh-keygen -R "${GUEST}"
[[ -d "${DOCKER_TMP_DIR}" ]] || mkdir -p "${DOCKER_TMP_DIR}"

echo "If \`$(basename ${DISABLE_SYNC_FLAG})\` exists, \`config.vm.synced_folder\` is disabled." > "${DISABLE_SYNC_FLAG}"
vagrant up && vagrant halt
rm "${DISABLE_SYNC_FLAG}"