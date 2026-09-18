case "$(tty)" in
  /dev/tty1)
    ( sleep 5; /bin/wpa_supplicant start ) >>/var/log/wifi-boot.log 2>&1 &

    export HOME=/data/home/root
    mkdir -p "$HOME"
    cd "$HOME"
    nnn
    ;;
esac
