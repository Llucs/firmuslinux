# Firmus Linux Architecture

## Overview

Firmus Linux is built on three pillars:

1. **Arch Linux base** — Uses the standard Arch Linux kernel (7.0.x), pacman package manager, systemd init system, and the Arch User Repository ecosystem
2. **Trusted Community Repository (TCR)** — A signed binary package repository hosted on GitHub Pages, providing verified builds of popular packages without local compilation
3. **Transactional updates** — Btrfs snapshots integrated with pacman hooks ensure every update is reversible

## Build Pipeline

```
┌──────────────────────────────────────────────────────────┐
│                    GitHub Actions                         │
│                                                          │
│  ┌──────────────┐    ┌──────────────┐                    │
│  │ build-iso.yml │    │ build-tcr.yml│                    │
│  │              │    │              │                    │
│  │ archiso      │    │ makepkg      │                    │
│  │ mkarchiso    │    │ repo-add     │                    │
│  │ qemu test    │    │ namcap check │                    │
│  └──────┬───────┘    └──────┬───────┘                    │
│         │                   │                            │
│         ▼                   ▼                            │
│  ┌──────────────────────────────────┐                    │
│  │          GitHub Release          │                    │
│  │  firmuslinux-YYYY.MM.DD-x86_64   │                    │
│  └──────────────────────────────────┘                    │
│                                                          │
│  ┌──────────────┐    ┌──────────────┐                    │
│  │ verify-aur   │    │ deploy-pages │                    │
│  │ daily scan   │    │ gh-pages     │                    │
│  │ hash allowlist│   │ pacman repo  │                    │
│  └──────────────┘    └──────────────┘                    │
└──────────────────────────────────────────────────────────┘
```

## Package Flow

```
AUR PKGBUILD → CI Verification → TCR Build → Signed Package → GitHub Pages
                                                                    │
                                                                    ▼
                                                          User's pacman -S
```

## System Integration

### Initramfs (Dracut-only)

Firmus uses `dracut` exclusively for initramfs generation. The configuration:
- Generates both UKI (`/boot/EFI/Linux/firmus.efi`) and standalone initramfs (`/boot/initramfs-linux.img`)
- Includes btrfs, snapper, and NVIDIA modules
- Uses zstd compression

### Snapshot System

Pre-transaction hook: `/etc/pacman.d/hooks/snapshot-pre.hook`
Post-transaction hook: `/etc/pacman.d/hooks/snapshot-post.hook`
Snapshots stored at: `/.snapshots/` (btrfs subvolume)

### TCR Repository

Served via GitHub Pages at `https://firmuslinux.github.io/firmuslinux/x86_64/`
Database maintained by `repo-add` in CI, pushed to `gh-pages` branch.
