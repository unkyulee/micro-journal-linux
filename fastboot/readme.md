# Building Fast Booting OS for Dedicated Writing Device

I wanted to build a fast boot for a writing device. When powered on it should be pretty smooth transition to starting typing. Waiting for a minute before the device is ready to type. It loses the momentum. 

Raspbian OS takes less than a minute to boot. I wanted to make it to sub 10 seconds. It's still more than ESP32 based devices. Which takes around 3 seconds to be ready to type. But, it's a huge difference compared to a minute. Target is below 10 seconds. At this speed, I feel like you don't get out of the attention span. You would still feel like the device is on in time. 

My approach is to build the Linux setup as minimal as possible and only contain minimal setup. Just enough to run Wordgrinder, or nano text editors on a terminal. This way, I can control what is going into the OS, and can micro manage what happens during the boot.

The level of knowledge that is required to handle such low level is beyond my skill level. So, with the clear objectives. I have used Ai to get the things done. I have gone with step by step approach and making the changes with my own hand after asking Ai what needs to be done.

Each step has been really, I mean really long to achieve. Since it's taking it off from the ground. For instance, to get the display panel to show texts, it took so long to make it happen. I take it for granted that modern systems, you can plug in the cable and things shows up in the display. Didn't know what I was jumping into. But, after a bazillions of trials, then finally to see the screen displaying booting logo and text. 

The joy was enormous. What's achieved is just getting the display to work. But, the process was so long and hopeless, that, when it worked. I had to raise my arm and scream out of joy. Who would understand. For others, I just had the text showing up in the display. My wife, politely saying. Oh yeah? When I said, I did it!! Now the display shows white texts!!

# Setup Buildroot

I want to talk about how the process went. Also, intending that someone who reads this, may try on their own or get the idea of the approach and apply on their problems. So, with the story, I will try to have the technical details as much as included. 

Buildroot is a software toolset. Where it allows to build a custom Linux OS. Not the fancy ones. But for the small devices, that requires very custom and minimal setup. Such as Kiosks. 

You will need to work on Linux for that matter. So, I downloaded Debian, and installed it on my PC. I had XFCE GUI environment. So, that I could feel a little familiar and hoping that things could feel more friendly when challenges may come. 

#### Download buildroot and run initial build

```bash

wget https://buildroot.org/downloads/buildroot-2026.08.tar.xz
tar xf buildroot-2026.08.tar.xz
cd buildroot-2026.08/

# Choose Raspberry Pi Zero 2W default setup
make raspberrypizero2w_64_defconfig
# exit without making any changes
make menuconfig
# takes 40 minutes to run all
make
```

These are the first command that I ran. What this will do is compile the Linux OS for Raspberry Pi Zero 2W with default configuration. Surprisingly. No issues were encountered during the step. It takes really long to complete. Around 30 minutes? 

Screen will be filled up with bunch of texts compiling and configuring the Linux OS. It's downloading all the codes for each software that goes in the OS, and compiling it. So, it's really fresh baked at your own PC. 

Once all the build is done. You will find sdcard.img which can be flashed to the micro SD card.

```bash
# SD card image location
/output/images/sdcard.img
```

Flash this file into the SD card, and plug in to the raspberry pi and you will see the Linux running on your device. I copied over to my Windows machine, and used Win32 Disk Imager to flash it.

This boots in 5 seconds. I would say, this is properly minimal setup. Which I find it fascinating and awesome to see Linux booting up so fast.

#### Setting Up the HDMI Display

I have connected to the wisecoco 7.8 inch display to the raspberry pi. Then nothing shows up. Panic. Is the display broken? Did it not boot correctly? All kinds of possible cause goes through my head. 

It's such a realization. I have never thought to worry about a monitor. You plug in HDMI cable from the device to the monitor. Then it works. It always worked. So, when it doesn't work. I don't even know where to start. I don't even have any scenarios where to start.

So, I asked Ai. Started digging up the wisecoco reference manual somewhere in the internet. I would have never known these details existed. Ai, started to spit out particular specifications of the wisecoco display module, and what settings I can try. 

There are few places to touch. 

**/board/raspberrypi/cmdline.txt**
```
root=/dev/mmcblk0p2 rootwait console=tty1 console=serial0,115200 logo.nologo quiet loglevel=0 vt.global_cursor_default=0
```

**/board/raspberrypi/config_zero2w_64bit.txt**
```bash
start_file=start.elf
fixup_file=fixup.dat

kernel=Image

# Enable 64-bit support
arm_64bit=1

# GPU memory
gpu_mem_256=100
gpu_mem_512=100
gpu_mem_1024=100

# Serial console on GPIO14/15
enable_uart=1
dtoverlay=miniuart-bt

disable_overscan=1

# Force HDMI output and ignore the panel's EDID
hdmi_force_hotplug=1
hdmi_ignore_edid=0xa5000080

# Custom mode 1280x400 @ 60Hz (CVT reduced blanking)
hdmi_group=2
hdmi_mode=87
hdmi_timings=400 0 100 10 140 1280 10 20 20 2 0 0 0 60 0 43000000 3
display_rotate=3

# HDMI signalling
hdmi_drive=2
config_hdmi_boost=7

# Remove Splash at the boot
disable_splash=1
boot_delay=0
```

```bash
# when changing cmdline.txt or config.txt
make rpi-firmware-rebuild
```

board/raspberrypi/linux-vc4-builtin.fragment

```bash
# Build the VC4/HDMI display driver directly into the kernel instead of
# as a loadable module, so the display attaches during kernel boot
# (deterministic) rather than whenever modprobe/udev happens to load it.
#
# DRM_VC4 hard-depends on SND && SND_SOC, so those must be builtin too;
# everything else it needs (DRM_KMS_HELPER, DRM_GEM_DMA_HELPER, etc.) is
# pulled in automatically via "select" during olddefconfig.
CONFIG_DRM=y
CONFIG_DRM_VC4=y
CONFIG_SND=y
CONFIG_SND_SOC=y
```


Compile after updating cmdline.txt and config.txt
```bash
make rpi-firmware-reinstall
make
```

Once the above configuration has been applied. Wide display module was starting show texts on the screen. It was a big relief. I would have stopped here because I could have never found a solution. It's such a deep technical detail, that would be so much information to process before reaching a solution. Thanks to Ai, I could find a solution, and move on to the next step.

All the details about HDMI settings are discovered after several times of trying different configurations. I feel vulnerable during these process. If you would need such details to show a text on the display and if some numbers are wrong then it would simply not working. Is this good approach to release it? What if display module changes in the future. Should I recompile and release a new build for each type of display controller? 

I am sure some of the smart people have already figured it out. In the modern Linux distribution. I was able to get it working with much simpler settings. I am just hoping that I don't have to visit this HDMI configuration another ttime.

What I learned is that. This portion of the changes are not actually part of the Linux itself. It's at the hardware level of the raspberry pi. So, the folder name "board" suggests. It is a portion about specific chips used in the board, and the how to setup the firmware and so on.


#### Auto Login

Right now, it's just asking for the login. It's not usable at this moment. I am going to work through step by step to reach a place where I can use this device as a writing machine.

I want to remove the login process. In Linux, or any operating systems. You would need to login for the security. But, this is not necessary in this case. I need to skip this part, so that when device turns on, it goes to the writing mode immediately. I can't ask the users to login. That would be 97% of the population going with "?" above their heads.

In order to achieve that. I need to modify the booting sequence. Which is modifying "/etc/inittab". Below script is where, once the compilation of the buildroot completes, it runs the script to modify the inittab. This specific scenario, it will open a shell prompt when the device boots.

```bash
# File location: /board/raspberrypi/post-build.sh
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
```

At this step, I understood more details about how buildroot works. It's preparing the Linux files in a folder called "target" and the above script is modifying the files. At this point. I wonder. Couldn't I just copy the inittab files directly? Without going through the hassle of modifying the content? 

EDIT: I asked Ai about it. Where is inittab file, and can I just have the file prepared instead of modifying it post build. I can have a file prepared and overwrite to the target which would be cleaner. Following configuration has been added to the raspberrypizero2w_64_defconfig and the inittab file is prepared accordingly.

```bash
BR2_ROOTFS_OVERLAY="board/raspberrypizero2w-64/rootfs-overlay"
```

After those changes were made. Now I see the screen no longer showing the login. Insteading showing "#" and waiting for commands. Yes!



#### Boot Into User Friendly Navigation

Now it's boot into the new display and bypassing the login screen. Then it shows the prompt. "#". In the wide screen there is a little character displaying. Waiting for commands from the users. This is intimidating. 

User wants to see what can you do with this device. I want to show list of options out of the box. Such as "New Document" or "New Text" or "WIFI Settings"... and so on. They would navigate with the cursor and press enter. This is what I want to achieve.

So, I chose "nnn". This is classic file navigation in the Linux world. Also, so default that it's included in the configuration. Previously, in the raspbian OS, I was using ranger. This is not really an option here. Because it requires Python, and it's heavy. It takes long to load. nnn will open up pretty much immediately. 

Now I have to tell buildroot to include nnn in the package. Also, during this step, I will include some text editors into the package as well. Such as, nano, emacs, vim. 

```bash
# add the following lines in the raspberrypizero2w_64_defconfig
# text editors
BR2_PACKAGE_NNN=y
BR2_PACKAGE_ED=y
BR2_PACKAGE_NANO=y
BR2_PACKAGE_UEMACS=y
BR2_PACKAGE_VIM=y
```

Then to make "nnn" to start at the boot. 

board/raspberrypi/rootfs-overlay/etc/profile.d/autostart-nnn.sh
```bash
case "$(tty)" in
  /dev/tty1)
    ( sleep 5; /bin/wpa_supplicant start ) >>/var/log/wifi-boot.log 2>&1 &

    export HOME=/data/home/root
    mkdir -p "$HOME"
    cd "$HOME"
    nnn
    ;;
esac
```

Now when you boot, a little terminal based interface is shown. Expecting users to move around with cursor. More scripts will be added in the later stage. 


#### Enabling WIFI

story will continue... 