# Contributing to Firmus Linux

## Package Submissions (TCR)

### Tier 1 — Core Firmus Packages

1. Fork the repository
2. Create a PKGBUILD in `packages/tcr/<package-name>/`
3. Ensure the PKGBUILD follows the [Arch packaging standards](https://wiki.archlinux.org/title/Creating_packages)
4. Submit a Pull Request
5. CI will: verify checksums, build in a clean container, run `namcap`
6. At least 2 maintainer approvals required for merge
7. Package is automatically signed and published to the TCR

### Tier 2 — Community Packages

Same process as Tier 1, but requires only 1 maintainer approval.

### Tier 3 — AUR Binary Cache

Submit a PR adding the package name to `packages/tcr/tier3.csv`. CI will:
1. Download the PKGBUILD from AUR
2. Verify against the hash allowlist
3. Build and publish if verification passes

## Bug Reports

Use the [Issue Tracker](https://github.com/firmuslinux/firmuslinux/issues) with the appropriate template.

## Development

### Building the ISO Locally

```bash
sudo pacman -S archiso
git clone https://github.com/firmuslinux/firmuslinux.git
cd firmuslinux/iso
sudo mkarchiso -v .
```

### Testing the ISO in QEMU

```bash
sudo pacman -S qemu-full
run_archiso -i out/firmuslinux-*.iso
```

### Building a TCR Package Locally

```bash
cd packages/tcr/<package-name>
makepkg -si
```

## Code of Conduct

- Be respectful and constructive
- Follow the Arch Linux packaging guidelines
- Test your changes before submitting
- Sign your commits with GPG
