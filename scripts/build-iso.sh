#!/usr/bin/env bash
# Firmus Linux — Local ISO build script
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ISO_DIR="$PROJECT_DIR/iso"
WORK_DIR="/tmp/firmus-iso-work"
OUT_DIR="$ISO_DIR/out"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${CYAN}[INFO]${NC} $*"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

check_dependencies() {
    local deps=("archiso" "mkarchiso")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            if [ "$dep" = "archiso" ]; then
                log_error "archiso not installed. Run: sudo pacman -S archiso"
                exit 1
            fi
        fi
    done
    log_ok "All build dependencies satisfied"
}

clean_work_dir() {
    if [ -d "$WORK_DIR" ]; then
        log_info "Cleaning working directory..."
        rm -rf "$WORK_DIR"
    fi
    if [ -d "$OUT_DIR" ]; then
        log_info "Cleaning output directory..."
        rm -rf "$OUT_DIR"
    fi
}

build_iso() {
    log_info "Starting ISO build..."
    log_info "Working directory: $WORK_DIR"
    log_info "Output directory: $OUT_DIR"

    mkdir -p "$OUT_DIR"
    mkdir -p "$WORK_DIR"

    cd "$ISO_DIR"
    mkarchiso -v -w "$WORK_DIR" -o "$OUT_DIR" .
}

verify_iso() {
    local iso_file
    iso_file=$(ls "$OUT_DIR"/*.iso 2>/dev/null | head -1)

    if [ -z "$iso_file" ]; then
        log_error "No ISO file found in $OUT_DIR"
        exit 1
    fi

    log_info "Verifying ISO: $iso_file"
    ls -lh "$iso_file"
    file "$iso_file"

    # Generate checksum
    sha256sum "$iso_file" > "${iso_file}.sha256"
    log_ok "Checksum: ${iso_file}.sha256"
    cat "${iso_file}.sha256"
}

main() {
    echo "========================================"
    echo "  Firmus Linux — ISO Builder"
    echo "========================================"
    echo ""

    check_dependencies

    if [ "${1:-}" = "--clean" ]; then
        clean_work_dir
    fi

    build_iso
    verify_iso

    log_ok "Build complete! ISO at: $OUT_DIR"
}

main "$@"
