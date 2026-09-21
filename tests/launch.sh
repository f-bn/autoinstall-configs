#!/usr/bin/env bash
set -euox pipefail

trap 'exit 130' INT

usage() {
  cat << EOF
Usage: launch.sh DEVICE VERSION

Launch a Fedora virtual machine for testing 'kickstart' configuration.

Arguments:
  DEVICE     Device name (values: buran, foton)
  VERSION    Fedora release version (e.g. 44)

Example:
  launch.sh buran 44

EOF
}

if [ $# -ne 2 ]; then
  usage; exit 1
fi

DEVICE="$1"
VERSION="$2"

case "${DEVICE}" in
  buran)
    KICKSTART_PATH="${PWD}/desktops/buran/fedora.ks"
    ;;
  foton)
    KICKSTART_PATH="${PWD}/laptops/foton/fedora.ks"
    ;;
  *)
    echo "Unsupported device: ${DEVICE}" >&2
    exit 1
    ;;
esac

ISO_PATH="${PWD}/tests/fedora-${VERSION}.iso"
CACHE_DIR="${PWD}/.cache/${DEVICE}"

# Setting up cache directory
mkdir -p "${CACHE_DIR}"

# Generate seed disk (OEMDRV ISO with kickstart file)
cp "${KICKSTART_PATH}" "${CACHE_DIR}/ks.cfg"
genisoimage -V OEMDRV -o "${CACHE_DIR}/seed.img" "${CACHE_DIR}/ks.cfg"

# Create VM disk image
qemu-img create -f qcow2 "${CACHE_DIR}/disk.img" 100G

# Copy OVMF firmware files
cp /usr/share/OVMF/OVMF_CODE.fd /usr/share/OVMF/OVMF_VARS.fd "${CACHE_DIR}"

# Run QEMU
QEMU_ARGS=(
  -accel kvm
  -machine q35
  -cpu host
  -smp 4
  -m 8G
  -cdrom "${ISO_PATH}"
  -device virtio-scsi-pci,id=scsi0
  -device scsi-cd,drive=seed,bus=scsi0.0
  -drive if=pflash,format=raw,readonly=on,file="${CACHE_DIR}/OVMF_CODE.fd"
  -drive if=pflash,format=raw,file="${CACHE_DIR}/OVMF_VARS.fd"
  -drive file="${CACHE_DIR}/seed.img",format=raw,cache=none,if=none,id=seed
  -drive file="${CACHE_DIR}/disk.img",format=qcow2,cache=unsafe,if=none,id=disk0
  -nic user,model=virtio-net-pci
  -vga virtio
)

# Manage disk interface based on device
if [ "${DEVICE}" = "foton" ] || [ "${DEVICE}" = "buran" ]; then
  QEMU_ARGS+=(
    -device nvme,drive=disk0,serial=disk0
  )
else
  QEMU_ARGS+=(
    -device scsi-hd,drive=disk0,bus=scsi0.0
  )
fi

exec /usr/bin/qemu-kvm "${QEMU_ARGS[@]}" || exit $?