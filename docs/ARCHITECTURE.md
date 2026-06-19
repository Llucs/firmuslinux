# Firmus Linux Architecture

## Overview

Firmus Linux is an Arch Linux derivative that prioritizes reliability, security, and zero-maintenance operation. It uses standard Arch Linux kernel (7.0.x), pacman, and systemd, while adding:

1. **TCR** — Trusted Community Repository for signed binary packages
2. **Dracut-only** — Unified initramfs generation
3. **Transactional updates** — Automatic btrfs snapshots before/after every update
4. **Automated hardware configuration** — NVIDIA, seat groups, bluetooth, printing

## Repository Structure

```
firmuslinux/
├── .github/workflows/     # CI/CD pipelines
├── iso/                   # archiso build profile
├── packages/tcr/          # TCR package definitions
├── calamares/             # Installer modules
├── configs/               # System configuration templates
├── scripts/               # Build and maintenance tools
├── branding/              # Themes and artwork
├── security/              # Security policies and keys
├── testing/               # Test suites
└── docs/                  # Documentation
```

## Build Pipeline

1. **ISO build** (weekly): GitHub Actions → archiso → ISO → GitHub Release
2. **TCR build** (weekly): CI reads tier CSVs → builds PKGBUILDs → signs → deploys to gh-pages
3. **AUR verification** (daily): Scans AUR → updates hash allowlist → opens issues for changes

## Package Distribution

TCR packages are served via GitHub Pages CDN at:
`https://firmuslinux.github.io/firmuslinux/x86_64/`

## Boot Process

1. systemd-boot or GRUB loads kernel + initramfs
2. dracut initramfs mounts root filesystem
3. systemd starts services
4. Snapshot timer starts, kernel cleanup runs
5. Display manager starts

## Key Design Decisions

- **Dracut over mkinitcpio**: Single initramfs tool avoids the mkinitcpio/dracut conflict that plagues EndeavourOS and Garuda
- **TCR over raw AUR**: Pre-built, signed, verified packages eliminate the AUR malware attack surface
- **Btrfs + snapper over ext4**: Transactional updates with one-command rollback
- **GitHub-only infrastructure**: Zero server cost, GitHub Actions for CI, Pages for repo, Releases for ISO distribution
