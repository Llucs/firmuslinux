#!/usr/bin/env bash
# Firmus Linux — Generate AUR PKGBUILD hash allowlist
set -euo pipefail

AUR_BASE_URL="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD"
OUTPUT_FILE="/tmp/aur-allowlist.json"

log_info() { echo "$(date '+%H:%M:%S') [INFO] $*"; }
log_ok() { echo "$(date '+%H:%M:%S') [OK] $*"; }
log_error() { echo "$(date '+%H:%M:%S') [ERROR] $*"; }

usage() {
    cat << EOF
Usage: $(basename "$0") <package-list-file>

Generate a SHA256 allowlist for AUR packages.
The input file should contain one package name per line.

Example:
  $(basename "$0") packages/tcr/tier3.csv
EOF
}

fetch_hash() {
    local pkg="$1"
    local url="$AUR_BASE_URL?h=$pkg"
    local sha

    sha=$(curl -sSfL "$url" 2>/dev/null | sha256sum | cut -d' ' -f1)

    if [ -z "$sha" ]; then
        log_warn "Failed to fetch PKGBUILD for '$pkg'"
        return 1
    fi

    echo "$sha"
}

generate_allowlist() {
    local input_file="$1"

    if [ ! -f "$input_file" ]; then
        log_error "File not found: $input_file"
        exit 1
    fi

    log_info "Generating allowlist from: $input_file"

    echo "{" > "$OUTPUT_FILE"
    echo '  "packages": {' >> "$OUTPUT_FILE"

    local first=true
    while IFS= read -r line; do
        line=$(echo "$line" | xargs)
        [ -z "$line" ] && continue
        [[ "$line" =~ ^# ]] && continue

        log_info "Fetching: $line"
        sha=$(fetch_hash "$line") || continue

        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$OUTPUT_FILE"
        fi

        echo -n "    \"$line\": \"$sha\"" >> "$OUTPUT_FILE"
    done < "$input_file"

    echo "" >> "$OUTPUT_FILE"
    echo "  }" >> "$OUTPUT_FILE"
    echo "}" >> "$OUTPUT_FILE"

    log_ok "Allowlist generated: $OUTPUT_FILE"
    jq '.' "$OUTPUT_FILE" > "${OUTPUT_FILE}.pretty" 2>/dev/null || true
}

main() {
    if [ $# -eq 0 ] || [ "${1:-}" = "--help" ]; then
        usage
        exit 0
    fi

    generate_allowlist "$1"
    log_ok "Allowlist contains $(jq '.packages | length' "$OUTPUT_FILE") packages"
}

main "$@"
