#!/bin/sh

set -u
set -e

# Read-only squashfs root + writable /data (F2FS) partition.
# Root itself can no longer be written to at runtime, so anything that
# needs to persist across reboots (e.g. saved WiFi credentials) must live
# under /data instead of /etc or /var.
mkdir -p "${TARGET_DIR}/data"
cat > "${TARGET_DIR}/etc/fstab" <<'EOF'
# <file system>	<mount pt>	<type>	<options>	<dump>	<pass>
/dev/root	/		squashfs	ro,noauto	0	0
/dev/mmcblk0p3	/data		f2fs	rw,noatime	0	0
proc		/proc		proc	defaults	0	0
devpts		/dev/pts	devpts	defaults,gid=5,mode=620,ptmxmode=0666	0	0
tmpfs		/dev/shm	tmpfs	mode=1777	0	0
tmpfs		/tmp		tmpfs	mode=1777	0	0
tmpfs		/run		tmpfs	mode=0755,nosuid,nodev	0	0
sysfs		/sys		sysfs	defaults	0	0
EOF

# Grow the /data partition to fill the rest of the SD card - as a manual
# command the user runs when they want it, NOT a boot-time service (keeps
# boot fast and avoids running sfdisk/resize.f2fs on every single boot).
# data.f2fs is built as a fixed 64M image (see post-image.sh) regardless of
# the actual card size; this expands the partition table entry (sfdisk) and
# then the filesystem itself (resize.f2fs) to use whatever space is left.
mkdir -p "${TARGET_DIR}/bin"
cat > "${TARGET_DIR}/bin/expand-fs" <<'EOF'
#!/bin/sh
# Grow /data to fill the rest of the SD card. Safe to run more than once -
# it just reports there's nothing to do if /data already uses all available
# space.

DISK=/dev/mmcblk0
PART=${DISK}p3
MNT=/data

DISK_SECTORS=$(cat /sys/block/mmcblk0/size 2>/dev/null)
PART_START=$(cat /sys/class/block/mmcblk0p3/start 2>/dev/null)
PART_SECTORS=$(cat /sys/class/block/mmcblk0p3/size 2>/dev/null)

if [ -z "$DISK_SECTORS" ] || [ -z "$PART_START" ] || [ -z "$PART_SECTORS" ]; then
	echo "expand-fs: could not read partition geometry"
	exit 1
fi

WANT_SECTORS=$((DISK_SECTORS - PART_START))

if [ "$PART_SECTORS" -ge "$WANT_SECTORS" ]; then
	echo "expand-fs: /data is already using all available space"
	exit 0
fi

echo "expand-fs: growing $PART from $PART_SECTORS to $WANT_SECTORS sectors"

umount "$MNT" 2>/dev/null

if ! echo ", +" | sfdisk -N 3 --no-reread "$DISK"; then
	echo "expand-fs: sfdisk failed"
	mount "$MNT" 2>/dev/null
	exit 1
fi

blockdev --rereadpt "$DISK" 2>/dev/null

if ! resize.f2fs "$PART"; then
	echo "expand-fs: resize.f2fs failed (partition table was already grown)"
	mount "$MNT" 2>/dev/null
	exit 1
fi

mount "$MNT" || { echo "expand-fs: remount of $MNT failed"; exit 1; }

echo "expand-fs: done"
EOF
chmod +x "${TARGET_DIR}/bin/expand-fs"

# Clean up the old boot-time version of this from earlier builds - it must
# not linger, since /etc/init.d/rcS would still auto-run it at boot.
rm -f "${TARGET_DIR}/etc/init.d/S02expand-data"

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:-/bin/sh' ${TARGET_DIR}/etc/inittab
# systemd doesn't use /etc/inittab, enable getty.tty1.service instead
elif [ -d ${TARGET_DIR}/etc/systemd ]; then
    mkdir -p "${TARGET_DIR}/etc/systemd/system/getty.target.wants"
    ln -sf /lib/systemd/system/getty@.service \
       "${TARGET_DIR}/etc/systemd/system/getty.target.wants/getty@tty1.service"
fi

# Auto-start nnn file explorer on the HDMI console.
# $HOME is redirected to /data (the writable partition) so nnn's own
# config/bookmarks/history (normally $HOME/.config/nnn) can actually persist
# across reboots instead of failing to write to the read-only root.
# WiFi is deliberately NOT started during the early boot sequence (it used
# to be an S-numbered init.d script) - it's kicked off here instead, in the
# background, a few seconds after nnn is already on screen, so a slow/flaky
# wifi association never delays getting to a usable UI. Output is redirected
# to a log file (not /dev/tty1) so it never draws over nnn's screen.
mkdir -p "${TARGET_DIR}/etc/profile.d"
cat > "${TARGET_DIR}/etc/profile.d/autostart-nnn.sh" <<'EOF'
case "$(tty)" in
  /dev/tty1)
    ( sleep 5; /etc/init.d/wpa_supplicant start ) >>/var/log/wifi-boot.log 2>&1 &

    export HOME=/data/home/root
    mkdir -p "$HOME"
    cd "$HOME"
    nnn
    ;;
esac
EOF

# WiFi firmware for this exact board/chip: upstream linux-firmware does not
# ship a real brcm/brcmfmac43430-sdio.raspberrypi,model-zero-2-w.bin (only
# other-board variants); fetched the real file from Raspberry Pi's own
# firmware-nonfree repo (where it exists as a symlink to brcmfmac43436s-sdio.bin)
mkdir -p "${TARGET_DIR}/lib/firmware/brcm"
cp "board/raspberrypi/firmware/brcm/brcmfmac43430-sdio.raspberrypi,model-zero-2-w.bin" \
   "${TARGET_DIR}/lib/firmware/brcm/"
cp "board/raspberrypi/firmware/brcm/brcmfmac43430-sdio.raspberrypi,model-zero-2-w.txt" \
   "${TARGET_DIR}/lib/firmware/brcm/"

# WiFi: wpa_supplicant daemon + interactive scan/connect script.
# Deliberately named without an "S" prefix so /etc/init.d/rcS's `S??*` glob
# does NOT auto-run it during boot - it's started later, in the background,
# from the nnn autostart hook above (see profile.d/autostart-nnn.sh).
# The config file (which wpa_cli's save_config writes back to) lives on the
# writable /data partition instead of the read-only /etc, and is
# bootstrapped there on first run if it doesn't exist yet.
mkdir -p "${TARGET_DIR}/etc/init.d"
rm -f "${TARGET_DIR}/etc/init.d/S45wpa_supplicant"

cat > "${TARGET_DIR}/etc/init.d/wpa_supplicant" <<'EOF'
#!/bin/sh

IFACE=wlan0
DAEMON=/usr/sbin/wpa_supplicant
CONF=/data/wpa_supplicant.conf
LOG=/var/log/wpa_supplicant.log

start() {
	printf 'Starting wpa_supplicant: '

	if [ ! -f "$CONF" ]; then
		cat > "$CONF" <<'WPACONF'
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
update_config=1
WPACONF
	fi

	modprobe brcmfmac 2>/dev/null

	i=0
	while [ ! -e /sys/class/net/$IFACE ] && [ $i -lt 10 ]; do
		sleep 1
		i=$((i + 1))
	done
	if [ ! -e /sys/class/net/$IFACE ]; then
		echo "FAIL ($IFACE never appeared, check dmesg)"
		return 1
	fi

	ip link set $IFACE up 2>/dev/null
	$DAEMON -B -i $IFACE -c $CONF -D nl80211 -f $LOG
	echo 'OK'

	# If $CONF has a saved network, give association a few seconds then
	# get a lease; bounded tries so this doesn't hang forever when no
	# network has been configured yet.
	sleep 8
	if udhcpc -i $IFACE -n -t 5 >/dev/null 2>&1; then
		# Board has no RTC, so the clock is wrong until a network is up -
		# sync it now that we actually have connectivity.
		ntpd -q -n -p pool.ntp.org >/dev/null 2>&1
	fi
}

stop() {
	printf 'Stopping wpa_supplicant: '
	killall wpa_supplicant >/dev/null 2>&1
	echo 'OK'
}

case "$1" in
	start|stop) "$1" ;;
	restart|reload) stop; start ;;
	*) echo "Usage: $0 {start|stop|restart}"; exit 1 ;;
esac
EOF
chmod +x "${TARGET_DIR}/etc/init.d/wpa_supplicant"

cat > "${TARGET_DIR}/usr/bin/wifi-setup" <<'EOF'
#!/bin/sh
# Interactive WiFi setup: scan for SSIDs, pick one, enter a password, connect.

IFACE=wlan0
CTRL=/var/run/wpa_supplicant

echo "Scanning for WiFi networks on $IFACE..."
wpa_cli -i "$IFACE" -p "$CTRL" scan >/dev/null
sleep 3

RESULTS=$(wpa_cli -i "$IFACE" -p "$CTRL" scan_results | tail -n +2)
if [ -z "$RESULTS" ]; then
	echo "No networks found. Try again in a few seconds."
	exit 1
fi

echo
echo "Available networks:"
n=0
echo "$RESULTS" | while IFS="$(printf '\t')" read -r bssid freq signal flags ssid; do
	n=$((n + 1))
	printf '%2d) %-32s signal=%s %s\n' "$n" "$ssid" "$signal" "$flags"
done

echo
printf 'Select network number: '
read -r choice

ssid=$(echo "$RESULTS" | sed -n "${choice}p" | cut -f5)
if [ -z "$ssid" ]; then
	echo "Invalid selection."
	exit 1
fi

echo "Selected: $ssid"
printf 'Password (leave blank for an open network): '
stty -echo
read -r psk
stty echo
echo

id=$(wpa_cli -i "$IFACE" -p "$CTRL" add_network)
wpa_cli -i "$IFACE" -p "$CTRL" set_network "$id" ssid "\"$ssid\"" >/dev/null
if [ -n "$psk" ]; then
	wpa_cli -i "$IFACE" -p "$CTRL" set_network "$id" psk "\"$psk\"" >/dev/null
else
	wpa_cli -i "$IFACE" -p "$CTRL" set_network "$id" key_mgmt NONE >/dev/null
fi
wpa_cli -i "$IFACE" -p "$CTRL" enable_network "$id" >/dev/null
wpa_cli -i "$IFACE" -p "$CTRL" save_config >/dev/null
sync
sync

echo "Connecting..."
sleep 5
wpa_cli -i "$IFACE" -p "$CTRL" status | grep -E '^wpa_state|^ssid'

echo "Requesting DHCP lease..."
if udhcpc -i "$IFACE"; then
	echo "Syncing clock..."
	ntpd -q -n -p pool.ntp.org >/dev/null 2>&1
fi

echo "Done."
EOF
chmod +x "${TARGET_DIR}/usr/bin/wifi-setup"
