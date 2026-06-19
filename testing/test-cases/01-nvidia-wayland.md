# Test Case: NVIDIA + Wayland

## Objective
Verify that NVIDIA GPUs are properly configured for Wayland compositors after installation.

## Prerequisites
- Machine with NVIDIA GPU
- Firmus Linux ISO

## Steps
1. Boot Firmus Linux ISO
2. Run `calamares` installer
3. Select any desktop environment (KDE/GNOME/Sway/Hyprland)
4. Complete installation
5. Reboot into installed system
6. Run: `lsmod | grep nvidia_drm`
7. Run: `cat /sys/module/nvidia_drm/parameters/modeset`
8. Run: `groups $USER`

## Expected Results
- `nvidia_drm` module is loaded
- `modeset` parameter equals `1`
- User is in `seat` group
- Wayland session starts without fallback to X11
- `nvidia-smi` reports GPU correctly

## Failure Conditions
- nvidia_drm not loaded
- modeset = 0
- Wayland session fails, falls back to X11
