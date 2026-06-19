#!/usr/bin/env bash
# Firmus Linux — Generate initial GPG signing key
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY_FILE="$SCRIPT_DIR/firmus.gpg"
KEY_NAME="Firmus Linux Signing Key"
KEY_EMAIL="signing@firmuslinux.org"

log_info() { echo "$(date '+%H:%M:%S') [INFO] $*"; }

if [ -f "$KEY_FILE" ]; then
    log_info "Key file already exists: $KEY_FILE"
    log_info "To regenerate, delete it first: rm $KEY_FILE"
    exit 0
fi

log_info "Generating Firmus Linux GPG signing key..."

cat > /tmp/firmus-key-gen-batch << EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $KEY_NAME
Name-Email: $KEY_EMAIL
Expire-Date: 2y
%commit
EOF

gpg --batch --gen-key /tmp/firmus-key-gen-batch

log_info "Exporting public key..."
gpg --armor --export "$KEY_EMAIL" > "$KEY_FILE"

log_info "Key generated: $KEY_FILE"
log_info "Import with: pacman-key --add $KEY_FILE"
log_info "Then: pacman-key --lsign-key \"$KEY_NAME\""
rm -f /tmp/firmus-key-gen-batch
