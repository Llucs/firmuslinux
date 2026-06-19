# Test Case: Transactional Update and Rollback

## Objective
Verify that `firmus-update` creates snapshots and `firmus-rollback` can restore the system.

## Prerequisites
- Firmus Linux installed with btrfs

## Steps
1. Run `firmus-update`
2. Verify snapshot was created: `snapper list | grep pre-update`
3. Make a system change (e.g., create a test file)
4. Run `firmus-rollback --list`
5. Note the pre-update snapshot number
6. Run `firmus-rollback --id <NUM>`
7. Reboot

## Expected Results
- `firmus-update` creates both pre and post-update snapshots
- `firmus-rollback --list` shows all snapshots with descriptions
- After rollback and reboot, the test file from step 3 is gone
- System boots normally after rollback
