#!/usr/bin/env bash
# Firmus Linux archiso profile definition

iso_name="firmuslinux"
iso_label="FIRMUS_$(date +%Y%m)"
iso_publisher="Firmus Linux <https://github.com/firmuslinux>"
iso_application="Firmus Linux Live/Installation Medium"
iso_version="$(date +%Y.%m.%d)"
install_dir="firmus"
buildmodes=('iso')
bootmodes=(
  'bios.syslinux.mbr'
  'bios.syslinux.eltorito'
  'uefi-x64.systemd-boot.esp'
  'uefi-x64.systemd-boot.eltorito'
  'uefi-x64.grub.esp'
  'uefi-x64.grub.eltorito'
)
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:700"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/bin/firmus-update"]="0:0:755"
  ["/usr/bin/firmus-rollback"]="0:0:755"
  ["/usr/bin/firmus-status"]="0:0:755"
  ["/usr/bin/firmus-verify"]="0:0:755"
  ["/usr/bin/firmus-initramfs"]="0:0:755"
)
