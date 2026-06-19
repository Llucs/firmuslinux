# Firmus Linux (WIP)

**Firmus** (Latin for *solid, firm, reliable*) — An Arch Linux distribution engineered for stability, security, and zero-maintenance operation.

## Why Firmus?

Arch Linux delivers the freshest software with a rolling release model, but it demands constant maintenance. Firmus preserves everything great about Arch — pacman, AUR compatibility, the Wiki, rolling updates — while solving the structural problems that make Arch a burden:

| Problem | Firmus Solution |
|---|---|
| AUR malware crisis (1,500+ compromised packages, June 2026) | **TCR** (Trusted Community Repository): CI-verified PKGBUILDs, signed binary packages, no local compilation |
| Initramfs chaos (mkinitcpio vs dracut) | **Dracut-only**: unified initramfs generation, UKI + standalone compatibility |
| NVIDIA + Wayland broken post-install | **Auto-configuration**: `nvidia_drm.modeset=1`, DKMS, seat groups |
| Updates break the system | **Transactional snapshots**: btrfs snapshot before every `pacman -Syu`, one-command rollback |
| Maintenance burden | **Flatpak-first** for GUI apps, TCR binary cache, staged testing pipeline |
| Infrastructure fragility | **100% GitHub**: ISO via Actions, package repo via Pages, releases via CDN |

## Quick Start

### Download

Download the latest ISO from the [Releases](https://github.com/firmuslinux/firmuslinux/releases) page.

### Write to USB

```bash
# Identify your USB device
lsblk

# Write the ISO
sudo dd if=firmuslinux-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

### Install

1. Boot from the USB
2. Run `calamares` (or click the "Install Firmus" desktop icon)
3. Follow the guided installer — NVIDIA, Btrfs snapshots, and TCR are configured automatically

### Post-Install

```bash
# Update the system (with automatic snapshot)
firmus-update

# Roll back if something breaks
firmus-rollback

# Check system status
firmus-status
```

## Repository Structure

```
firmuslinux/
├── .github/workflows/       # CI/CD: ISO build, TCR package build, AUR verification
├── iso/                      # archiso profile — builds the live ISO
├── packages/tcr/             # PKGBUILDs for the Trusted Community Repository
├── calamares/                # Calamares installer modules
├── configs/                  # System-wide default configurations
├── scripts/                  # Build and maintenance scripts
├── branding/                 # GRUB, Plymouth, SDDM themes
├── security/                 # TCR policy, signing keys, audit logs
├── testing/                  # ISO smoke tests, package tests
└── docs/                     # Architecture and contribution documentation
```

## Package Repository (TCR)

Firmus maintains a binary package repository hosted on GitHub Pages:

```ini
# /etc/pacman.conf
[firmus]
SigLevel = Required TrustedOnly
Server = https://firmuslinux.github.io/firmuslinux/x86_64
```

The TCR is organized in tiers:

| Tier | Description | Review |
|---|---|---|
| **Tier 1** | Core Firmus packages (keyring, configs) | Human review + CI |
| **Tier 2** | Community-maintained, verified packages | Automated CI verification |
| **Tier 3** | Popular AUR packages, binary cache | Allowlist-based automated build |

## Security

- All TCR packages are signed with the Firmus GPG key
- PKGBUILD verification runs in isolated CI containers
- AUR packages are checked against a signed hash allowlist before local builds
- Orphaned AUR packages are automatically adopted and verified

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on package submissions, bug reports, and development.

## License

Firmus Linux build scripts and configurations are licensed under GPL-3.0. Individual packages retain their original licenses.

---

Built on [Arch Linux](https://archlinux.org) infrastructure using [archiso](https://gitlab.archlinux.org/archlinux/archiso) and [Calamares](https://calamares.io).
