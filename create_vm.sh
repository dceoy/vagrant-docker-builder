#!/usr/bin/env bash
#
# Usage:  ./create_vm.sh
#         ./create_vm.sh [ -h | --help | -v | --version | --run | --sudo ]
#
# Description:
#   Create a virtual machine using ./Vagrantfile.
#
# Options:
#   -h, --help          Print usage
#   -v, --version       Print version information and quit
#   --run               Run the virtual machine after setup
#   --sudo              Use `sudo` to execute Vagrant

set -e

if [[ "${1}" = '--debug' ]]; then
  set -x
  shift 1
fi

SCRIPT_NAME='create_vm.sh'
SCRIPT_VERSION='1.1.0'
GUEST='[127.0.0.1]:2222'
TMP_DIR="tmp"
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

function abort {
  echo "${SCRIPT_NAME}: ${*}" >&2
  exit 1
}

function sudo_e {
  if [[ -n "${SUDO_E}" ]]; then
    sudo -E ${*}
  else
    ${*}
  fi
}

while [[ -n "${1}" ]]; do
  case "${1}" in
    '-v' | '--version' )
      print_version
      exit 0
      ;;
    '-h' | '--help' )
      print_usage
      exit 0
      ;;
    '--sudo' )
      SUDO_E=1
      shift 1
      ;;
    '--run' )
      VM_RUN=1
      shift 1
      ;;
    * )
      abort "invalid argument \`${1}\`"
      ;;
  esac
done

echo "[Vagrant version]" && sudo_e "vagrant --version"
echo "[VBoxManage version]" && sudo_e "VBoxManage --version"
echo

[[ $(grep -cF ${GUEST} ~/.ssh/known_hosts) -gt 0 ]] && ssh-keygen -R ${GUEST}
[[ -d "${DOCKER_TMP_DIR}" ]] || mkdir -p ${DOCKER_TMP_DIR}
[[ -f 'config.yml' ]] || cp example_config.yml config.yml

if [[ $(grep -ce '^[^#]\+_proxy:' config.yml) -gt 0 ]]; then
  if [[ $(vagrant plugin list | grep -ce '^vagrant-proxyconf ') -eq 0 ]]; then
    sudo_e "vagrant plugin install vagrant-proxyconf"
  else
    sudo_e "vagrant plugin update vagrant-proxyconf"
  fi
fi

echo "This file disables \`config.vm.synced_folder\`" > ${DISABLE_SYNC_FLAG}
echo

sudo_e "vagrant up"

rm ${DISABLE_SYNC_FLAG}
echo

if [[ -n "${VM_RUN}" ]]; then
  sudo_e "vagrant reload"
else
  sudo_e "vagrant halt"
fi
