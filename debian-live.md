Download debian live image

debian-live-13.2.0-amd64-lxde.iso


Setup persistent partition size using Rufus 

Prepare at least 8 GB size drive

flash the image with persistent partition using rufus


modifiy grub settings to boot immediately to live 

in boot/grub folder of the USB
config.cfg file
add at the top


set timeout=0
set timeout_style=hidden



boot with the drive


puppy linux root


woofwoof




nmtui




```bash
nano ~/microjournal/wifi.sh
```

Add the following content:

```bash
sudo nmtui
```

---

3. Make the Script Executable

```bash
chmod +x ~/microjournal/wifi.sh
```


how to auto login


sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo nano /etc/systemd/system/getty@tty1.service.d/override.conf


[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin microjournal --noclear %I $TERM



sudo systemctl daemon-reload
sudo systemctl restart getty@tty1
