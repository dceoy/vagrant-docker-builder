#!/usr/bin/env bash
#
# Usage:  ./create_vm.sh
#         ./create_vm.sh [ -h | --help | -v | --version | --run ]
#
# Description:
#   Create a virtual machine using ./Vagrantfile.
#
# Options:
#   -h, --help          Print usage
#   -v, --version       Print version information and quit
#   --run               Run the virtual machine after setup

set -e
if [[ "${1}" = '--debug' ]]; then
  set -x
  shift 1
fi

SCRIPT_NAME='create_vm.sh'
SCRIPT_VERSION='1.0.0'
GUEST='[127.0.0.1]:2222'
SHARE_DIR="share"
TMP_DIR="${SHARE_DIR}/tmp"
DISABLE_SYNC_FLAG="${TMP_DIR}/disable_synced_folder"
DOCKER_TMP_DIR="${TMP_DIR}/docker"

function print_version {
  echo "${SCRIPT_NAME}: ${SCRIPT_VERSION}"
}

function print_usage {
  sed -ne '
    1,2d
    /^#/!q
    s/^#$/# /
    s/^# //p
  ' ${SCRIPT_NAME}
}

case "${1}" in
  '-v' | '--version' )
    print_version
    exit 0
    ;;
  '-h' | '--help' )
    print_usage
    exit 0
    ;;
  '--run' )
    VM_RUN=true
    ;;
esac

echo "[Vagrant version]" && vagrant --version
echo "[VBoxManage version]" && VBoxManage --version

if [[ -f 'config.yml' ]] && [[ "$(grep -ce '^[^#]\+_proxy:' config.yml)" -gt 0 ]]; then
  if [[ $(vagrant plugin list | grep -ce '^vagrant-proxyconf ') -eq 0 ]]; then
    vagrant plugin install vagrant-proxyconf
  else
    vagrant plugin update vagrant-proxyconf
  fi
fi

[[ "$(grep -cF ${GUEST} ~/.ssh/known_hosts)" -gt 0 ]] && ssh-keygen -R "${GUEST}"
[[ -d "${DOCKER_TMP_DIR}" ]] || mkdir -p "${DOCKER_TMP_DIR}"

echo "\`config.vm.synced_folder\` is disabled." > "${DISABLE_SYNC_FLAG}"
vagrant up
rm "${DISABLE_SYNC_FLAG}"
[[ -n "${VM_RUN}" ]] && vagrant reload || vagrant halt
