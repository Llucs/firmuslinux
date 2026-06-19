#!/usr/bin/env bash
# Firmus Linux — ISO smoke test
set -euo pipefail

QEMU_MEM="${QEMU_MEM:-2G}"
QEMU_SMP="${QEMU_SMP:-2}"
QEMU_TIMEOUT="${QEMU_TIMEOUT:-120}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${CYAN}[INFO]${NC} $*"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

usage() {
    cat << EOF
Usage: $(basename "$0") <iso-file>

Boot a Firmus Linux ISO in QEMU for basic smoke testing.

Environment variables:
  QEMU_MEM        Memory for QEMU (default: 2G)
  QEMU_SMP        CPU cores for QEMU (default: 2)
  QEMU_TIMEOUT    Timeout in seconds (default: 120)

Example:
  $(basename "$0") iso/out/firmuslinux-2026.06.19-x86_64.iso
EOF
}

check_dependencies() {
    local deps=("qemu-system-x86_64" "qemu-img")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            log_error "$dep not found. Install with: sudo pacman -S qemu-full"
            exit 1
        fi
    done
}

verify_iso() {
    local iso="$1"
    if [ ! -f "$iso" ]; then
        log_error "ISO file not found: $iso"
        exit 1
    fi

    log_info "ISO: $iso"
    ls -lh "$iso"
    file "$iso"

    # Check for checksum file
    if [ -f "${iso}.sha256" ]; then
        cd "$(dirname "$iso")"
        sha256sum -c "$(basename "${iso}.sha256")" && log_ok "Checksum verified"
        cd -
    fi
}

create_test_disk() {
    local disk="/tmp/firmus-test-disk.img"
    log_info "Creating test disk: $disk"
    qemu-img create -f qemu-img "$disk" 10G >/dev/null 2>&1 || \
    qemu-img create -f raw "$disk" 10G >/dev/null 2>&1
    echo "$disk"
}

boot_iso() {
    local iso="$1"
    local disk
    disk=$(create_test_disk)

    log_info "Booting ISO in QEMU (timeout: ${QEMU_TIMEOUT}s)..."
    log_info "Memory: $QEMU_MEM, CPUs: $QEMU_SMP"

    timeout "$QEMU_TIMEOUT" qemu-system-x86_64 \
        -m "$QEMU_MEM" \
        -smp "$QEMU_SMP" \
        -cdrom "$iso" \
        -boot d \
        -nographic \
        -no-reboot \
        -serial mon:stdio \
        -drive file="$disk",format=raw,if=virtio \
        -device virtio-net,netdev=net0 \
        -netdev user,id=net0 \
        -device virtio-rng-pci \
        2>&1 || true

    log_info "QEMU session ended"
}

main() {
    if [ $# -eq 0 ] || [ "${1:-}" = "--help" ]; then
        usage
        exit 0
    fi

    local iso="${1:-}"

    echo "========================================"
    echo "  Firmus Linux — ISO Smoke Test"
    echo "========================================"
    echo ""

    check_dependencies
    verify_iso "$iso"
    boot_iso "$iso"

    echo ""
    log_warn "Smoke test completed (manual inspection required)"
}

main "$@"
