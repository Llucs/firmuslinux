# Audit Log: Initial Repository Setup

**Date**: 2026-06-19
**Author**: Llucs
**Action**: Initial repository creation and TCR setup

## Summary
Created the Firmus Linux repository structure, archiso profile, TCR package definitions, Calamares installer modules, and CI/CD pipelines.

## Changes
- Initialized monorepo structure
- Created archiso profile for ISO generation
- Defined Tier 1 core packages (keyring, mirrorlist, settings)
- Created Calamares installer modules for NVIDIA, seat, snapper, bootloader, TCR, desktop
- Implemented GitHub Actions workflows (build-iso, build-tcr, verify-aur, deploy)
- Established TCR tier policy and package submission process
- Created system configuration defaults (dracut-only, btrfs snapshots, kernel cleanup)

## Sign-off
- GPG key: Firmus Linux Signing Key (newly created)
- Status: Complete
