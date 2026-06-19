# Test Case: Btrfs Snapshots

## Objective
Verify that automatic snapshots are created before and after package operations.

## Prerequisites
- Firmus Linux installed with btrfs root filesystem

## Steps
1. Boot into installed system
2. Run: `snapper list`
3. Install a package: `sudo pacman -S htop`
4. Run: `snapper list`

## Expected Results
- Snapshot configuration exists at `/etc/snapper/configs/root`
- At least one pre-update snapshot exists after step 3
- `snapper list` shows snapshots with valid timestamps
- Rollback via `firmus-rollback --id <NUM>` restores previous state

## Failure Conditions
- No snapshot configuration
- Snapshot creation fails
- Rollback results in broken system
