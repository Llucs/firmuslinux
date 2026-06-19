#!/usr/bin/env bash
# Firmus Linux — Build a single TCR package in isolated environment
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PKG_DIR="$PROJECT_DIR/packages/tcr"

log_info() { echo "$(date '+%H:%M:%S') [INFO] $*"; }
log_ok() { echo "$(date '+%H:%M:%S') [OK] $*"; }
log_error() { echo "$(date '+%H:%M:%S') [ERROR] $*"; }

usage() {
    cat << EOF
Usage: $(basename "$0") <package-name> [--install]

Build a TCR package from its PKGBUILD directory.

Arguments:
  <package-name>  Name of the package directory in packages/tcr/
  --install       Install the package after building (optional)

Example:
  $(basename "$0") firmus-keyring
  $(basename "$0") firmus-settings --install
EOF
}

check_pkgbuild() {
    local pkg="$1"
    local pkgbuild="$PKG_DIR/$pkg/PKGBUILD"

    if [ ! -f "$pkgbuild" ]; then
        log_error "PKGBUILD not found: $pkgbuild"
        exit 1
    fi
    log_info "Found PKGBUILD for '$pkg'"
}

build_package() {
    local pkg="$1"
    local install="${2:-}"

    cd "$PKG_DIR/$pkg"

    log_info "Building '$pkg'..."

    if [ "$install" = "--install" ]; then
        makepkg -si --noconfirm
    else
        makepkg -s --noconfirm
    fi

    local pkg_file
    pkg_file=$(ls *.pkg.tar.zst 2>/dev/null | head -1)
    if [ -n "$pkg_file" ]; then
        log_ok "Built: $pkg_file"
        ls -lh "$pkg_file"
    fi
}

run_namcap() {
    local pkg="$1"
    local pkg_file

    cd "$PKG_DIR/$pkg"
    pkg_file=$(ls *.pkg.tar.zst 2>/dev/null | head -1)

    if [ -n "$pkg_file" ] && command -v namcap &>/dev/null; then
        log_info "Running namcap on '$pkg_file'..."
        namcap "$pkg_file" || true
    fi
}

main() {
    if [ $# -eq 0 ] || [ "${1:-}" = "--help" ]; then
        usage
        exit 0
    fi

    local pkg="${1:-}"
    local install="${2:-}"

    check_pkgbuild "$pkg"
    build_package "$pkg" "$install"
    run_namcap "$pkg"

    log_ok "Package '$pkg' built successfully"
}

main "$@"
