SKIPUNZIP=0

ui_print "- Realme C53 (RMX3760) - panel pengganti TD4160"
PANEL_NAME=$(cat /sys/devices/platform/soc/soc:ap-ahb/31100000.dsi/31100000.dsi.0/display/panel0/name 2>/dev/null)
if [ "$PANEL_NAME" != "lcd_td4160_cw_old_mipi_hd" ]; then
    ui_print "! Panel: ${PANEL_NAME:-?} - tuning mungkin tidak cocok"
else
    ui_print "- Panel cocok: $PANEL_NAME"
fi

ui_print "- Flag aktif default:"
ui_print "    CABC off + watchdog"
ui_print "    DPU min 384MHz + governor perf"
ui_print "- enhanceHAL tidak disentuh (kompensasi panel)"
ui_print "- Refresh rate tidak disentuh, ikut firmware"
set_perm_recursive $MODPATH 0 0 0755 0644
