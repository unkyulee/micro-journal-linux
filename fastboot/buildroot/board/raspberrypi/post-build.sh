#!/bin/sh

set -u
set -e

# Execute Permission on the scripts
chmod +x "${TARGET_DIR}/usr/bin/expand-fs"
chmod +x "${TARGET_DIR}/usr/bin/wpa_supplicant"
chmod +x "${TARGET_DIR}/usr/bin/wifi-setup"


# WiFi firmware for this exact board/chip: upstream linux-firmware does not
# ship a real brcm/brcmfmac43430-sdio.raspberrypi,model-zero-2-w.bin (only
# other-board variants); fetched the real file from Raspberry Pi's own
# firmware-nonfree repo (where it exists as a symlink to brcmfmac43436s-sdio.bin)
mkdir -p "${TARGET_DIR}/lib/firmware/brcm"
cp "board/raspberrypi/firmware/brcm/brcmfmac43430-sdio.raspberrypi,model-zero-2-w.bin" \
   "${TARGET_DIR}/lib/firmware/brcm/"
cp "board/raspberrypi/firmware/brcm/brcmfmac43430-sdio.raspberrypi,model-zero-2-w.txt" \
   "${TARGET_DIR}/lib/firmware/brcm/"




