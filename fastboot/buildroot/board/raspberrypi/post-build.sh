#!/bin/sh

set -u
set -e

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

# Auto-start nnn file explorer on the HDMI console
mkdir -p "${TARGET_DIR}/etc/profile.d"
cat > "${TARGET_DIR}/etc/profile.d/autostart-nnn.sh" <<'EOF'
case "$(tty)" in
  /dev/tty1)
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

# WiFi: wpa_supplicant daemon (started at boot) + interactive scan/connect script
mkdir -p "${TARGET_DIR}/etc/init.d"
cat > "${TARGET_DIR}/etc/wpa_supplicant.conf" <<'EOF'
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
update_config=1
EOF

cat > "${TARGET_DIR}/etc/init.d/S45wpa_supplicant" <<'EOF'
#!/bin/sh

IFACE=wlan0
DAEMON=/usr/sbin/wpa_supplicant
CONF=/etc/wpa_supplicant.conf
LOG=/var/log/wpa_supplicant.log

start() {
	printf 'Starting wpa_supplicant: '

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
chmod +x "${TARGET_DIR}/etc/init.d/S45wpa_supplicant"

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

echo "Connecting..."
sleep 5
wpa_cli -i "$IFACE" -p "$CTRL" status | grep -E '^wpa_state|^ssid'

echo "Requesting DHCP lease..."
udhcpc -i "$IFACE"

echo "Done."
EOF
chmod +x "${TARGET_DIR}/usr/bin/wifi-setup"
