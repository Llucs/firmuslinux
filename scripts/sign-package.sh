#!/usr/bin/env bash
# Firmus Linux — Sign a package with the Firmus GPG key
set -euo pipefail

GPG_KEY_ID="Firmus Linux Signing Key"

log_info() { echo "$(date '+%H:%M:%S') [INFO] $*"; }
log_ok() { echo "$(date '+%H:%M:%S') [OK] $*"; }
log_error() { echo "$(date '+%H:%M:%S') [ERROR] $*"; }

usage() {
    cat << EOF
Usage: $(basename "$0") <package-file>

Sign a .pkg.tar.zst package with the Firmus GPG key.

Requires:
  - GPG key with ID "$GPG_KEY_ID" in the keyring
  - The package file to sign

Example:
  $(basename "$0") mypackage-1.0-1-x86_64.pkg.tar.zst
EOF
}

check_dependencies() {
    if ! command -v gpg &>/dev/null; then
        log_error "gpg not found. Install with: pacman -S gnupg"
        exit 1
    fi
}

sign_package() {
    local pkg_file="$1"

    if [ ! -f "$pkg_file" ]; then
        log_error "File not found: $pkg_file"
        exit 1
    fi

    log_info "Signing: $pkg_file"

    if gpg --detach-sign --default-key "$GPG_KEY_ID" --output "${pkg_file}.sig" "$pkg_file" 2>/dev/null; then
        log_ok "Signature created: ${pkg_file}.sig"
    else
        log_error "Failed to sign package. Is the GPG key present?"
        log_info "Import key: pacman-key --add /usr/share/firmus/keyring/firmus.gpg"
        exit 1
    fi
}

main() {
    if [ $# -eq 0 ] || [ "${1:-}" = "--help" ]; then
        usage
        exit 0
    fi

    check_dependencies
    sign_package "$1"
    log_ok "Package signed successfully"
}

main "$@"
