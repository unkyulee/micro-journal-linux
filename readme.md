# Micro Journal Linux Image

This repository contains all the setup instructions, scripts, and configuration guides for the [Micro Journal](https://github.com/unkyulee/micro-journal) Linux Image. This image is designed for [Micro Journal](https://github.com/unkyulee/micro-journal) revisions that run on a Raspberry Pi, providing a lightweight, portable, and fully functional system tailored for writing and file management.

You have two main options to get started. The simplest and recommended approach is to use a prebuilt image. This allows you to flash the system onto a microSD card and boot immediately, with everything already configured. For those who prefer a deeper understanding or want to customize the system extensively, you can also set up everything manually. 

This setup method works also on any Debian-based PC configuration. A live USB image is also available for experimentation or testing. There are many better options out there. So, before committing to PC version. Try [writerDeckOS](https://www.reddit.com/r/writerdeckOS/) which is specifically focus on building a focused writing environtment for PC.

Beyond simply running the system, this repository also tells a story about how the Micro Journal Linux Image is built. Each script, configuration file, and setup step reflects a choice made to balance simplicity, functionality, and portability. By following these instructions, you don't just get a working device. You get a window into the design decisions behind it, allowing you to understand why things are set up the way they are. It's like looking under the hood of a machine that's been carefully tuned for writers, tinkerers, and makers alike.

This is more than just installation instructions. It's an invitation to explore, experiment, and even improve the system for your own needs. Plaese, enjoy.

* [Download Micro Journal Linux Image](https://github.com/unkyulee/micro-journal-linux/releases)

---

## Table of Contents

### Introduction

* Micro Journal Linux Image Overview
* Prebuilt Image vs Manual Installation
* Live USB Image for PC

### Flashing the Prebuilt Image

### Manual Installation (Advanced)

* Requirements
* Install Raspberry Pi OS Lite
* Rotate Display to Landscape
* Fix Wi-Fi Handshake Bug
* Enable Auto Login (Optional)
* Set Up Wi-Fi
* Update the System

### App Installation

* Install Ranger as the Startup File Manager
* Install WordGrinder (Text Editor)
* Install File Browser (Web-based File Explorer)
* Console Font Size Adjuster
* Raspi-Config Shortcut

### Script Setup

* Script: Create a New WordGrinder File
* Shutdown Script
* Speed Up Boot Time
* Mount USB Disk
* Safe USB Removal
 

### Setting Unicode Language Support

* Korean Input
* Chinese Input
* Japanese Input




---

## Introduction

### Micro Journal Linux Image Overview

The **Micro Journal Linux Image** is a lightweight, purpose-built system designed to run on Micro Journal devices powered by the Raspberry Pi. It transforms your device into a dedicated, writing focused workspace for writing, note-taking, and file management, while keeping the system simple, fast, and portable.

Every component of this image is carefully configured to create a seamless experience. From the startup scripts to the file manager setup. It includes a console-based file manager, a minimal text editor, and optional tools like a web-based file browser, all optimized to work out of the box. The image is fully open-source, giving you the flexibility to understand, modify, or extend it as you see fit.

In essence, the Linux Image is more than a pre-configured OS. It's a toolkit, a learning resource, and a starting point for anyone who wants to explore how a small, portable Linux system can be tailored for real-world writing and productivity.


### Prebuilt Image vs. Manual Installation

To get started, there are two main approaches.

**1. Prebuilt Image (Recommended)**

The easiest way to start is by using the prebuilt image. It comes fully configured, so you can flash it onto a microSD card and start using your Micro Journal immediately. This method is ideal for users who want a reliable, ready-to-go system without spending time on manual setup. It's perfect for those who want to focus on writing rather than system configuration.

**2. Manual Installation (Advanced)**

For those who enjoy learning, customizing, or optimizing every detail, manual installation offers full control over the system. This approach lets you set up each component yourself, understand the inner workings of the image, and adapt it to other Debian-based systems or PC configurations. Manual installation is also a great way to experiment, troubleshoot, or modify the setup to fit specific needs, giving you insight into the design decisions behind the Micro Journal Linux Image.


**3. Live USB Image for PC**

In addition to running on Raspberry Pi devices, the Micro Journal Linux Image can also be used as a **live USB system** on a standard PC. This option allows you to boot the Micro Journal environment directly from a USB drive, without installing anything on your hard drive. It's a convenient way to experience the full functionality of the system on almost any computer, whether you're testing, traveling, or using a temporary setup.

The live USB image preserves the same features as the Raspberry Pi version. The console-based file manager, WordGrinder text editor, optional web-based file browser, and all the supporting scripts that make the Micro Journal environment so smooth and portable. By booting from USB, you can carry your Micro Journal system in your pocket and run it on multiple PCs, all while keeping your workflow consistent.

This approach is particularly useful for experimenting or troubleshooting. You can explore the system's setup, inspect scripts, and even test manual installations without affecting your main operating system. It's also a great entry point for new users who want to try Micro Journal without committing to a Raspberry Pi device.

If your focus is purely on a **PC-based, distraction-free writing environment**, you might also want to check out [writerDeckOS](https://www.reddit.com/r/writerdeckOS/). It's a project specifically designed to create a focused writing workspace for PC users, with a minimal interface and optimized tools to help writers stay productive.

Download the PC image from the release page, and use the ImageUSB tool to flash the image to USB drive.

* [Download ImageUSB tool](./imageusb.zip)
* [Download Micro Journal Linux Image](https://github.com/unkyulee/micro-journal-linux/releases)


---

## Flashing the Prebuilt Image 

> **⚠️ Warning:** Flashing will erase **all data** on the SD card. Make sure to back up any important files before proceeding.

Flashing a prebuilt image is the fastest and simplest way to get your Micro Journal up and running. This method requires minimal technical knowledge and ensures that all the system configurations, scripts, and tools are correctly installed from the start.

**Steps to Flash the Image:**

1. **Download the Image**
   Download `microjournal.rev.2.xxxx.xx.xx.zip` from the [release section](https://github.com/unkyulee/micro-journal-linux/releases). This ZIP file contains the full disk image, ready to be written to a microSD card.

2. **Install BalenaEtcher**
   BalenaEtcher is a free and cross-platform tool that simplifies the flashing process. Install it on your computer and follow the prompts to prepare for writing the image.

3. **Flash the Image to a microSD Card**
   Insert a microSD card (4 GB minimum, 8 GB or larger recommended) into your computer. Open BalenaEtcher, select the downloaded image, and choose your SD card as the target. Click **Flash**. This may take a few minutes depending on your card and computer speed.

4. **Insert the SD Card and Power On**
   Once flashing is complete, safely eject the microSD card and insert it into your Micro Journal Rev.2. Power the device on. The system should boot immediately into the preconfigured Linux environment.


---

## Manual Installation

### Requirements

Before starting the manual installation, make sure you have the following:

* **Raspberry Pi Zero 2W**
* **microSD card** (4 GB minimum, 8 GB+ recommended for more flexibility)
* **PC with SD card reader**
* **Micro Journal Rev.2 series hardware**


The manual installation process allows you to set up the Micro Journal Linux environment **from scratch**, giving you full control over every step. By following the instructions in the sections below, you will replicate the exact configuration of the prebuilt image. Every script, command, and configuration is included, so your manually installed system will behave identically to the prebuilt version.

This approach is ideal for:

* Users who want to understand the inner workings of the Micro Journal system.
* Those who want to customize or extend the system during installation.
* Experimenters who wish to adapt the setup to other Debian-based systems or PCs.

---

### Install Raspberry Pi OS Lite

The first step in manually setting up your Micro Journal is installing a base operating system. **Raspberry Pi OS Lite** is a minimal, lightweight version of the Raspberry Pi operating system, providing just enough functionality to run the Micro Journal environment without unnecessary services or bloat. Using a lightweight OS ensures faster boot times, better stability, and less resource usage. Important for a portable, battery-powered device like the Micro Journal.

**Steps:**

1. **Download Raspberry Pi Imager**
   This tool simplifies the process of writing an OS to your microSD card. It ensures the image is correctly formatted and flashed, reducing the chance of boot errors.

2. **Insert your microSD card**
   The microSD card is where the OS will live. A minimum of 4 GB is required, but 8 GB or larger is recommended to provide enough space for your documents, scripts, and optional tools.

3. **Select device: Raspberry Pi Zero 2W**
   Choosing the correct device ensures the image is configured with the proper drivers and settings for your hardware. Without this, the system may fail to boot or certain hardware components (like Wi-Fi or display) may not work.

4. **Select OS: Raspberry Pi OS Lite (64-bit)**
   The Lite version provides a minimal environment, avoiding unnecessary desktop environments or GUI packages. This keeps the system fast and lightweight, which is ideal for a focused writing device.

5. **Configure Wi-Fi and user credentials**
   Setting up Wi-Fi at this stage allows your device to connect to the network immediately after the first boot. Creating user credentials ensures you have secure access to the system.

6. **Flash the card**
   Flashing writes the OS image to the microSD card and prepares it for boot. This step is essential because it transforms a blank microSD card into a fully bootable system ready for the Micro Journal setup.


---

### Rotate Display to Landscape

The Micro Journal uses a **Wisecoco 7.84-inch 1280×400 LCD display**, which has a unique aspect ratio that differs from standard monitors. By default, Raspberry Pi OS may not correctly detect the orientation or resolution of this display, which can result in distorted graphics or a misaligned interface. This step ensures that the system outputs the video signal correctly, with the display rotated to landscape mode and scaled to fit the screen perfectly.

If you are using a standard monitor or a display that automatically detects orientation and resolution, this step is **not necessary** and can be skipped. The system will handle standard displays automatically.

**Steps to Rotate the Display:**

1. Open `cmdline.txt` on the boot partition of your microSD card from PC
2. Add the following at the end of the single line (do not add a line break):

```
video=HDMI-A-1:400x1280M@60,rotate=90  
```

3. Example of a complete line:

```
console=tty1 rootwait video=HDMI-A-1:400x1280M@60,rotate=90  
```

4. Save the file, safely eject the card from the PC, and then install it on raspberry Pi then boot the Micro Journal.

After reboot, the interface should display correctly in landscape orientation, matching the dimensions of the Wisecoco LCD.

---

### Fix Wi-Fi Handshake Bug

Certain Wi-Fi routers can cause connection failures on the Raspberry Pi Zero 2W due to quirks in the Broadcom Wi-Fi chipset. Specifically, during the handshake process, the device may fail to authenticate or maintain a stable connection. This can prevent the Micro Journal from connecting to your network reliably, which is critical if you want to use features like file sharing, updates, or web-based tools.

This step modifies the Broadcom Wi-Fi driver configuration to **disable roaming** and **turn off certain features** that can interfere with the handshake process. Applying this fix ensures a more stable and reliable Wi-Fi connection, especially on modern or enterprise routers that enforce stricter handshake protocols.

**Steps to Apply the Fix:**

1. Open the driver configuration file:

```bash
sudo nano /etc/modprobe.d/brcmfmac.conf
```

2. Add the following line at the end of the file:

```
options brcmfmac roamoff=1 feature_disable=0x82000
```

3. Save the file and reboot the system.

After reboot, the Raspberry Pi should handle Wi-Fi connections more reliably, reducing failed handshakes and improving overall connectivity.

> **Tip:** If your Micro Journal connects fine without this fix (for example, on a home router with default settings), you can skip this step. However, applying it provides extra stability for a wider range of networks.


---

### Enable Auto Login

By default, Raspberry Pi OS requires you to enter a username and password at each boot. Enabling **auto login** allows the Micro Journal to boot directly into the console without prompting for credentials. This is particularly useful for a dedicated, portable device like the Micro Journal, where convenience and speed are priorities. Auto login ensures the system is immediately ready to use after power-on, without extra steps, making it ideal for a focused writing workflow.

**Steps to Enable Auto Login:**

```bash
# Run Raspberry Pi configuration
sudo raspi-config

# In the configuration navigate through:
# System Options → Boot / Auto Login → Console Autologin
```

**When to Skip Auto Login:**

* If you want your Micro Journal to require a password on each boot for **security reasons**.
* If the device may be used in public spaces or shared environments, where preventing unauthorized access is important.

```
Note: The default login credentials for the Micro Journal are:
Username: microjournal
Password: microjournal
```

Enabling auto login is optional and depends on your use case. For personal, portable use where convenience is prioritized, it can greatly streamline the startup experience. If security is a concern, it's safer to leave login enabled.


---

### Set Up Wi-Fi

Connecting your Micro Journal to a Wi-Fi network allows you to access the web-based file browser, sync documents, and install updates. This step configures your Raspberry Pi to automatically connect to your preferred wireless network on boot.

> **Important:** The Raspberry Pi Zero 2W only supports **2.4 GHz Wi-Fi networks**. Make sure your router is broadcasting a 2.4 GHz signal, as the device will not detect 5 GHz networks. Additionally, setting the correct Wi-Fi country ensures regulatory compliance and improves connection stability.

**Steps to Set Up Wi-Fi:**

```bash
# Run Raspberry Pi Configuration
sudo raspi-config

# In the configuration screen navigate:
# System Options → Wireless LAN
```

1. Select your Wi-Fi network and enter the password.

2. Optionally, set the **Wi-Fi country**:

   ```text
   Localisation Options → L4 WLAN Country
   ```

   Choosing the correct country enables the proper wireless channels and power limits for your region.

3. After configuration, **reboot the device** to ensure the network is properly initialized.



---

### Speed Up Boot Time

To make the Micro Journal boot faster, you can analyze which services delay startup and disable the ones you don't need.

---

1. Analyze Boot Performance

Use this command to see which services take the longest during boot:

```bash
systemd-analyze blame
```

This will output a list of all systemd services sorted by startup time, allowing you to identify potential slowdowns.

---

2. Disable Unnecessary Services

If your device doesn't require networking tools or background package updates, you can disable them to reduce startup time.

```bash
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily-upgrade.service
sudo systemctl disable apt-daily.timer
sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable ModemManager.service
sudo systemctl disable bluetooth.service
sudo systemctl disable triggerhappy.service
sudo systemctl disable hciuart.service
sudo systemctl disable avahi-daemon.service
```



---

3. Reduce Logging

On Pi Zero 2W, journald logging overhead is noticeable.

Edit:
```bash
sudo nano /etc/systemd/journald.conf
```

Set:
```ini
Storage=volatile
RuntimeMaxUse=16M
```

This keeps logs in RAM → fewer SD card writes.



---




## App Installation

For first-time setup, it's recommended to run this command **before installing any additional applications** to avoid compatibility issues.

**Steps to Update:**

```bash
sudo apt update
sudo apt upgrade
```

**Explanation:**

1. `sudo apt update` – Refreshes the package list from the repositories. This checks for the latest available versions of software and updates metadata about new packages.
2. `sudo apt upgrade` – Installs the updated packages and dependencies. This ensures that all installed software is up-to-date.


---

### Install Ranger as the Startup File Manager

Ranger is a lightweight, console-based file manager that provides a simple and efficient way to navigate your files directly from the terminal. On the Micro Journal, Ranger will serve as the main interface for browsing and managing your documents.

### Steps to Install and Configure Ranger

1. **Install Ranger:**
   Open a terminal and run:

   ```bash
   sudo apt install ranger
   ```

   This will download and install Ranger along with any required dependencies.

2. **Create a Documents Folder:**
   To organize your writing, create a dedicated folder for your files:

   ```bash
   mkdir -p ~/microjournal/documents
   ```

3. **Set Ranger to Launch on Startup:**
   You can configure Ranger to automatically start whenever you open a terminal session. Edit your bash configuration:

   ```bash
   nano ~/.bashrc
   ```

   Scroll to the bottom of the file and add the following lines:

   ```bash
   # Launch Ranger on startup
   cd ~/microjournal
   ranger
   ```

   Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`). Now, whenever you start a terminal, it will automatically open in the Micro Journal documents directory using Ranger.

4. **Configure File Associations:**
   Ranger allows you to define which applications open specific file types. Create or edit the configuration file:

   ```bash
   nano ~/.config/ranger/rifle.conf
   ```

   Add the following lines to associate file extensions with the appropriate applications:

   ```
   ext wg = wordgrinder "$@"
   ext sh = bash "$@"
   ext txt = micro "$@"
   ```

   * `ext wg` associates `.wg` files with WordGrinder, the text editor used on Micro Journal.
   * `ext sh` allows you to run shell scripts directly from Ranger.


* After this setup, Ranger will start in your `~/microjournal` folder automatically.
* You can always open Ranger manually from any directory by typing `ranger` in the terminal.
* Adjusting the `rifle.conf` file allows you to add more file associations as needed.


---

### Install WordGrinder and Micro (Text Editor)

Micro Journal uses **WordGrinder** and **Micro** as text editors. WordGrinder is a minimalistic, distraction-free editor optimized for writing documents, while Micro is a modern, terminal-based text editor with syntax highlighting and optional word wrap.

---

1. Install the Editors

Open a terminal and run:

```bash
sudo apt install wordgrinder micro
```

This will install both editors along with any necessary dependencies.

---

2. Configure Micro Editor

To improve the writing experience in Micro, enable word wrap so long lines automatically wrap in the terminal window:

* Edit Micro's settings file:

```bash
nano ~/.config/micro/settings.json
```

* Add or update the line:

```json
{
  "softwrap": true
}
```

* Save (`Ctrl + O`, `Enter`) and exit (`Ctrl + X`).

---

**Micro Shortcuts**

* **Save file:** `Ctrl + s`
* **Exit editor:** `Ctrl + q`

---

**WordGrinder Shortcuts**

* **Save file:** `Ctrl + s`
* **Exit editor:** `Ctrl + q`


---

### Install File Browser (Web-based File Explorer)

File Browser is a lightweight web-based file manager that allows you to browse, upload, and manage your documents from any device on the same network. On Micro Journal, it provides an easy way to access your writing files from a browser without needing to connect a keyboard or monitor.

---

1. Install File Browser

Run the following command to download and install File Browser:

```bash
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
```

This script automatically installs the latest version of File Browser and sets up the executable on your system.

---

2. Create a Launch Script

To make it easy to start the File Browser, create a script called `share.sh`:

```bash
nano ~/microjournal/share.sh
```

Add the following content:

```bash
#!/bin/bash

# Display access information
echo "########################################"
echo "Open http://$(hostname -I | awk '{print $1}'):8080"
echo "Press Ctrl+C to exit"
echo "########################################"

# Launch File Browser in the foreground
filebrowser -r ~/microjournal/documents -a 0.0.0.0 --noauth -d ~/file.db
```

---

3. Make the Script Executable

```bash
chmod +x ~/microjournal/share.sh
```




---

## Script Setup


### Console Font Size Adjuster

This small helper script lets you quickly change the console font size (useful on small screens).

**Create the script:**

```bash
nano ~/microjournal/font.sh
```

**Add:**

```bash
#!/bin/bash
sudo dpkg-reconfigure console-setup
```

This opens the Debian font configuration menu, where you can choose different console fonts and sizes.

**Make it executable:**

```bash
chmod +x ~/microjournal/font.sh
```

---

#### Raspi-Config Shortcut

This script gives you quick access to **raspi-config**, while ensuring that **NetworkManager** stays active so network settings aren't interrupted.

**Create the script:**

```bash
nano ~/microjournal/config.sh
```

**Add:**

```bash
#!/bin/bash

# Launch Raspberry Pi configuration tool
sudo raspi-config

```

**Make it executable:**

```bash
chmod +x ~/microjournal/config.sh
```


---

### Script: Create a New WordGrinder File

This script automatically creates a new WordGrinder document with a **timestamped filename** so your notes stay neatly organized.

**Create the script:**

```bash
nano ~/microjournal/new_word.sh
```

**Add:**

```bash
#!/bin/bash

# Generate filename: 2025.11.16-1430.wg
filename=$(date +"%Y.%m.%d-%H%M.wg")

# Open WordGrinder with the new file inside /documents
wordgrinder "~/microjournal/documents/$filename"
```

**Make it executable:**

```bash
chmod +x ~/microjournal/new_word.sh
```

Now you can simply run:

```
~/microjournal/new_word.sh
```

…and instantly start writing.

---


### Script: Create a New Text File

This script automatically creates a new text file with a **timestamped filename** so your notes stay neatly organized.

**Create the script:**

```bash
nano ~/microjournal/new_txt.sh
```

**Add:**

```bash
#!/bin/bash

# Generate filename: 2025.11.16-1430.txt
filename=$(date +"%Y.%m.%d-%H%M.txt")

# Open WordGrinder with the new file inside /documents
micro "~/microjournal/documents/$filename"
```

**Make it executable:**

```bash
chmod +x ~/microjournal/new_txt.sh
```

Now you can simply run:

```
~/microjournal/new_txt.sh
```

…and instantly start writing.

---

### Shutdown Script

A simple script that cleanly powers off the device.

**Create the script:**

```bash
nano ~/microjournal/shutdown.sh
```

**Add:**

```bash
#!/bin/bash
sudo shutdown now
```

**Make executable:**

```bash
chmod +x ~/microjournal/shutdown.sh
```

Now you can shut down your Micro Journal with:

```
~/microjournal/shutdown.sh
```


---

### USB Disk Mounting + Safe Removal Scripts

#### Mount USB Disk

```
nano ~/microjournal/usb_disk_connect.sh
```

```bash
#!/bin/bash
MOUNTPOINT="$HOME/microjournal/DISK"

DEVICE=$(lsblk -rpo "name,type,mountpoint" | awk '$2=="part" && $3=="" {print $1; exit}')

if [ -n "$DEVICE" ]; then
    mkdir -p "$MOUNTPOINT"
    sudo mount -o uid=$UID,gid=$(id -g),umask=022 "$DEVICE" "$MOUNTPOINT"
    sudo chmod 777 -R "$MOUNTPOINT"
    echo "Device $DEVICE mounted to $MOUNTPOINT."
fi

# Prompt user to press any key
read -n 1 -s -r -p "Press any key to continue..."
echo

```

```
chmod +x ~/microjournal/usb_disk_connect.sh
```

---

#### Safe USB Removal

```
nano ~/microjournal/usb_disk_safe_remove.sh
```

```bash
#!/bin/bash

# The mount point you want to safely remove
MOUNTPOINT="$HOME/microjournal/DISK"

# Check if it exists and is mounted
if mountpoint -q "$MOUNTPOINT"; then
    echo "Flushing filesystem buffers..."
    sync

    echo "Unmounting $MOUNTPOINT..."
    sudo umount "$MOUNTPOINT"

    if [ $? -eq 0 ]; then
        echo "USB disk safely removed."
        # Optionally remove the folder
        rmdir "$MOUNTPOINT" 2>/dev/null
    else
        echo "Error: Could not unmount $MOUNTPOINT"
        # Prompt user to press any key
        read -n 1 -s -r -p "Press any key to continue..."
        echo
    fi
else
    echo "No USB disk mounted at $MOUNTPOINT."
fi

# Prompt user to press any key
read -n 1 -s -r -p "Press any key to continue..."
echo
```

```
chmod +x ~/microjournal/usb_disk_safe_remove.sh
```


---

# **Setting Unicode Language Support**

Korean, Chinese, and Japanese input require a graphical environment because the console cannot handle complex input method engines (IME).
Micro Journal can support these languages by using **Xorg + IBus (or Fcitx)**.
Below is the setup for **Korean input**, which you can follow similarly for other CJK languages.

---

# **Korean Input**

This section is **only needed if you want to type Korean (Hangul)** on the Micro Journal.

The device normally boots into a **console-only interface**, which is lightweight and fast but **cannot handle IMEs**.
To enable Korean input, we install a **minimal X11 environment** with:

* **Xorg** (graphics server)
* **Openbox** (tiny window manager)
* **Konsole** (terminal emulator)
* **IBus + Hangul engine**

This keeps the system extremely small yet fully capable of Korean text input.

---

## **1. Enable Korean Locale**

Korean input requires the UTF-8 locale `ko_KR.UTF-8`.

```bash
sudo apt update
sudo dpkg-reconfigure locales
```

In the menu, enable:

```
ko_KR.UTF-8 UTF-8
```

You may choose it as default or keep English and add Korean as an additional locale.

---

## **2. Install Minimal X11 + Fonts + Hangul Input Method**

Install the minimal GUI components and Korean-capable fonts:

```bash
sudo apt install xorg openbox konsole fonts-nanum fonts-noto-cjk ibus ibus-hangul
```

This installs **only what is necessary**—no full desktop environment.

---

## **3. Create Openbox Autostart Script**

This script runs automatically when X11 starts.

* Configures IBus environment variables
* Starts the IBus daemon
* Opens Konsole in fullscreen for writing

Create the file:

```bash
mkdir -p ~/.config/openbox
nano ~/.config/openbox/autostart
```

Add:

```sh
#!/bin/sh

# Enable IBus input method
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# Start IBus daemon with Hangul support
ibus-daemon -drx

# Launch Konsole in fullscreen (no menu or tab bars)
konsole --fullscreen --noclose --hide-menubar --hide-tabbar
```

Make it executable:

```bash
chmod +x ~/.config/openbox/autostart
```

---

## **4. Configure Screen Rotation on GUI Startup**

The Micro Journal display is rotated; X11 needs to match that orientation.

```bash
nano ~/.xinitrc
```

Add:

```sh
#!/bin/sh

# Rotate screen to match hardware orientation
xrandr --output HDMI-1 --rotate left &

# Start Openbox window manager
exec openbox-session
```

Make it executable:

```bash
chmod +x ~/.xinitrc
```

---

## **5. Auto-Start X11 on Boot**

Start the GUI automatically when logging into TTY1:

```bash
nano ~/.bash_profile
```

Add:

```bash
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    startx
fi
```

Now the device will boot directly into a fullscreen GUI terminal with Hangul support.

---

## **6. Configure Hangul Input (Final Step)**

After rebooting into the GUI environment:

```bash
ibus-setup
```

Here you will:

* Add **Korean – Hangul**
* Set the toggle shortcut (default: **Ctrl+Space**)
* Adjust layout preferences

### ❗ Important Notes

* `ibus-setup` is difficult to use on the Micro Journal's small screen.
* It is recommended to connect:

  * A **larger HDMI monitor**
  * A **USB mouse**

Once configured, Hangul input will work automatically every time X11 starts.




---

# **Chinese Input**

This section is **only needed if you want to type Simplified Chinese** on the Micro Journal.

Like Korean input, Chinese IMEs (Pinyin, LibPinyin) require a **graphical X11 environment** because they cannot run inside the console. This guide installs a minimal GUI environment plus Chinese fonts and the IBus Pinyin engine.

---

## **1. Enable Chinese Locale**

Chinese input requires the locale `zh_CN.UTF-8`.

```bash
sudo apt update
sudo dpkg-reconfigure locales
```

In the menu, enable:

```
zh_CN.UTF-8 UTF-8
```

You may keep English as default while adding Chinese support.

---

## **2. Install Chinese Fonts**

To properly display Chinese characters in the terminal and GUI applications:

```bash
sudo apt-get install \
fonts-arphic-bkai00mp \
fonts-arphic-bsmi00lp \
fonts-arphic-gbsn00lp \
fonts-arphic-gkai00mp \
xfonts-intl-chinese \
xfonts-intl-chinese-big
```

These fonts cover both Simplified and Traditional Chinese glyph sets.

---

## **3. Install Minimal X11 + IBus Pinyin**

Install the graphical environment and the Chinese Pinyin IME:

```bash
sudo apt install xorg openbox konsole ibus ibus-pinyin ibus-libpinyin
```

This provides:

* **Xorg** as the display server
* **Openbox** as a lightweight window manager
* **Konsole** as the terminal
* **IBus Pinyin / LibPinyin** for Chinese input

---

## **4. Create Openbox Autostart Script**

This script runs when X11 starts and ensures that IBus is initialized before opening the terminal.

```bash
mkdir -p ~/.config/openbox
nano ~/.config/openbox/autostart
```

Add:

```sh
#!/bin/sh

# Enable IBus input method
export GTK_IM_MODULE=ibus
export XMODIFIDERS=@im=ibus
export QT_IM_MODULE=ibus

# Start IBus daemon (Chinese IME)
ibus-daemon -drx

# Launch fullscreen Konsole
konsole --fullscreen --noclose --hide-menubar --hide-tabbar
```

Make it executable:

```bash
chmod +x ~/.config/openbox/autostart
```

---

## **5. Configure GUI Screen Rotation**

The GUI must rotate to match the Micro Journal’s physical display orientation.

```bash
nano ~/.xinitrc
```

Add:

```sh
#!/bin/sh

# Rotate screen to match hardware layout
xrandr --output HDMI-1 --rotate left &

# Start Openbox
exec openbox-session
```

Make it executable:

```bash
chmod +x ~/.xinitrc
```

---

## **6. Auto-Start X11 at Boot**

Start the Chinese-enabled GUI automatically on TTY1:

```bash
nano ~/.bash_profile
```

Add:

```bash
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    startx
fi
```

---

## **7. Configure Pinyin Input (Final Step)**

After rebooting into the GUI, run:

```bash
ibus-setup
```

Use this to:

* Enable **Chinese – Pinyin / LibPinyin**
* Set trigger key (e.g., **Ctrl+Space**)
* Configure input preferences

### ⚠️ Note:

The setup window is small and harder to navigate on the Micro Journal’s screen.
For easiest configuration:

* Use a **larger HDMI monitor**
* Connect a **USB mouse**

After configuration, Chinese input will work automatically on every boot.

---

# **Japanese Input**

Japanese input on the Micro Journal uses:

* **X11** (minimal GUI)
* **fcitx** (input framework)
* **Mozc** (Japanese IME engine)
* Japanese fonts

This section mirrors the structure used for Korean and Chinese input.

---

## **1. Enable Japanese Locale**

```bash
sudo dpkg-reconfigure locales
```

Enable:

```
ja_JP.UTF-8 UTF-8
```

---

## **2. Install Japanese Fonts**

These fonts provide high coverage for Japanese characters:

```bash
sudo apt-get install \
xfonts-intl-japanese \
xfonts-intl-japanese-big \
fonts-takao
```

---

## **3. Install fcitx + Mozc**

Japanese IME uses Mozc (Google Japanese Input engine):

```bash
sudo apt-get install \
fcitx \
fcitx-mozc
```

> fcitx is recommended for Japanese; it tends to work better than IBus for Mozc.

---

## **4. Configure Input Method Framework**

Open the IME configuration tool:

```bash
sudo im-config
```

Follow the on-screen steps:

1. First screen → **OK**
2. Second screen → **YES** (explicit user configuration)
3. Third screen → Select:

```
(*) fcitx  — activate Flexible Input Method Framework
```

Then confirm.

---

## **5. Reboot and Select Japanese Input**

After rebooting:

* A keyboard icon appears in the GUI panel
* Right-click → **Input Method** → select **Mozc**
* Toggle between English and Japanese with **Ctrl+Space**

You now have full Japanese input support in the GUI terminal.

---



## Credits

* Hardware & project by **Un Kyu Lee**
* Wi-Fi fix provided by **Hollis Potter**

---

## Contact

For issues or suggestions, please open a GitHub Issue or contact the project owner.
