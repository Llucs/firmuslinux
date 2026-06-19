# TCR (Trusted Community Repository) Policy

## Overview

The TCR is Firmus Linux's curated, signed, binary package repository. It bridges the gap between Arch Linux's official repositories and the AUR by providing verified builds of popular packages.

## Tier Structure

### Tier 1 — Core Firmus Packages
- **Maintainers**: Firmus core team
- **Review**: Human review + CI verification required
- **Signing**: Requires 2 GPG signatures from different maintainers
- **Contents**: `firmus-keyring`, `firmus-settings`, `firmus-dracut-config`, etc.
- **Update frequency**: On commit to main branch

### Tier 2 — Community Packages
- **Maintainers**: Verified community contributors
- **Review**: Automated CI verification; 1 maintainer approval
- **Signing**: 1 GPG signature
- **Contents**: Community-maintained packages
- **Update frequency**: Weekly CI build

### Tier 3 — AUR Binary Cache
- **Maintainers**: Automated
- **Review**: Hash allowlist verification against AUR PKGBUILD
- **Signing**: Automated signing in CI
- **Contents**: Popular AUR packages (see `tier3.csv`)
- **Update frequency**: Weekly CI build

## Submission Process

1. Fork the repository
2. Add PKGBUILD to `packages/tcr/<package>/`
3. Submit Pull Request
4. CI runs: `namcap` lint, build test, dependency check
5. Maintainer review
6. Merge → automatic build → sign → publish to TCR

## Security Requirements

- All packages must be open source (GPL/MIT/Apache/BSD compatible)
- PKGBUILD must not download or execute unsigned code during build
- Source URLs must use HTTPS
- Checksums must be pinned (no `SKIP` without justification)
- No binary blobs without source

## Package Removal

A package may be removed if:
- Upstream is abandoned for 6+ months
- Security vulnerability cannot be resolved within 30 days
- Package violates the TCR policy
- Package has a direct replacement in Arch official repositories
