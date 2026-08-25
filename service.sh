#!/system/bin/sh
MODDIR=${0%/*}
LOG=/data/adb/lcd_max_td4160.log

DISABLE_CABC=1
DPU_PERF=1

PANEL=/sys/devices/platform/soc/soc:ap-ahb/31100000.dsi/31100000.dsi.0/display/panel0
DPU=/sys/devices/platform/dpu-dvfs/devfreq/dpu

log() { echo "$(date '+%m-%d %H:%M:%S') $1" >> $LOG; }

until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done
sleep 8

log "=== LCD Max TD4160 v2.2 start ==="

cek_firmware() {
    MODE=$(settings --user 0 get secure display_color_mode 2>/dev/null)
    case "$MODE" in
        0) LBL="saturated";; 1) LBL="auto";; 2) LBL="alami/natural";; 3) LBL="menyala/adaptive";; *) LBL="${MODE:-null}";;
    esac
    TMP=$(settings --user 0 get secure sprd_display_color_temperature_mode 2>/dev/null)
    pgrep -f vendor.sprd.hardware.enhance-service >/dev/null && ENH=on || ENH=off
    FPS=$(cat $PANEL/panel_fps 2>/dev/null)
    log "fw: color_mode=$MODE($LBL) suhu=$TMP enhanceHAL=$ENH panel_fps=$FPS"
}
cek_firmware

if [ "$DISABLE_CABC" = "1" ] && [ -w "$PANEL/cabc_private" ]; then
    echo 0 > $PANEL/cabc_private && log "cabc_private=0"
fi

if [ "$DPU_PERF" = "1" ]; then
    if [ -f "$DPU/min_freq" ]; then
        MAXF=$(cat $DPU/available_frequencies | awk '{print $NF}')
        echo $MAXF > $DPU/min_freq 2>/dev/null && log "dpu min_freq=$MAXF"
    fi
    GOV=$(cat $DPU/available_governors 2>/dev/null)
    case "$GOV" in *performance*) echo performance > $DPU/governor 2>/dev/null && log "dpu governor=performance";; esac
fi


(
while true; do
    sleep 10
    if [ "$DISABLE_CABC" = "1" ]; then
        C=$(cat $PANEL/cabc_private 2>/dev/null)
        [ "$C" = "0" ] || { echo 0 > $PANEL/cabc_private 2>/dev/null && log "cabc re-applied"; }
    fi
    cek_firmware
done
) &
