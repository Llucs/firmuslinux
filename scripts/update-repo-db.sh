#!/usr/bin/env bash
# Firmus Linux — Update TCR repository database
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
REPO_DIR="$PROJECT_DIR/repo/x86_64"
REPO_NAME="firmus"

log_info() { echo "$(date '+%H:%M:%S') [INFO] $*"; }
log_ok() { echo "$(date '+%H:%M:%S') [OK] $*"; }
log_error() { echo "$(date '+%H:%M:%S') [ERROR] $*"; }

check_packages() {
    if ! ls "$REPO_DIR"/*.pkg.tar.zst &>/dev/null 2>&1; then
        log_error "No packages found in $REPO_DIR"
        exit 1
    fi
    log_info "Found packages in $REPO_DIR"
}

clean_old_databases() {
    rm -f "$REPO_DIR/$REPO_NAME.db" \
          "$REPO_DIR/$REPO_NAME.db.tar.zst" \
          "$REPO_DIR/$REPO_NAME.db.tar.zst.sig" \
          "$REPO_DIR/$REPO_NAME.files" \
          "$REPO_DIR/$REPO_NAME.files.tar.zst" \
          "$REPO_DIR/$REPO_NAME.files.tar.zst.sig"
    log_info "Cleaned old database files"
}

create_database() {
    log_info "Creating repository database..."
    cd "$REPO_DIR"
    repo-add --sign "$REPO_NAME.db.tar.zst" *.pkg.tar.zst
    log_ok "Repository database created"
}

create_symlinks() {
    cd "$REPO_DIR"
    ln -sf "$REPO_NAME.db.tar.zst" "$REPO_NAME.db" 2>/dev/null || true
    ln -sf "$REPO_NAME.files.tar.zst" "$REPO_NAME.files" 2>/dev/null || true
}

main() {
    echo "========================================"
    echo "  Firmus Linux — TCR Database Updater"
    echo "========================================"
    echo ""

    check_packages
    clean_old_databases
    create_database
    create_symlinks

    log_ok "Repository updated: $REPO_DIR"
    ls -lh "$REPO_DIR/"
}

main "$@"
