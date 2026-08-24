# Panel Guard — Realme C53 / C50

Realme C53/C50 sering dipasangi layar LCD bukan pabrik. Panel semacam ini punya karakter
sendiri: respons warna beda dari panel asli, kadang memudar sendiri di konten tertentu,
dan fitur hemat daya layar justru membuatnya makin buruk.

Panel Guard adalah modul Magisk yang menjaga layar OEM tetap tampil sebaik mungkin —
dengan cara **mengikuti keputusan firmware, bukan melawannya**. Tidak ada penguncian
refresh rate, tidak ada penulisan partisi, tidak ada perubahan boot image. Semua yang
dilakukan modul bisa hilang total dengan mencopot modulnya.

## Yang dikerjakan modul

- Menjaga CABC tetap mati. CABC adalah fitur hemat daya yang meredupkan layar mengikuti
  isi gambar; pada panel OEM efeknya terlihat sebagai pudar mendadak. Firmware kadang
  menyalakannya diam-diam, modul mengecek dan mematikan lagi tiap dua menit.
- Menahan DPU (penggerak tampilan) agar tidak turun dari 384 MHz. Ini membuat animasi
  dan swipe recents jarang menampilkan frame basah.
- Membaca keputusan firmware — mode warna yang dipilih, suhu warna, status kalibrasi,
  dan refresh rate aktif — lalu mencatatnya ke log. Modul hanya membaca, tidak
  menginterveni.

## Yang sengaja tidak disentuh

- Kebijakan refresh rate dan whitelist 90 Hz firmware berjalan utuh.
- Kalibrasi warna bawaan (enhanceHAL) dibiarkan bekerja; hasil pengujian justru
  menunjukkan tanpa kalibrasi ini tampilan lebih pudar.
- Tidak ada HDR, wide color gamut, atau HBM yang dipaksakan — itu batas fisik panel,
  bukan sesuatu yang bisa dibuat lewat software.

## Spesifikasi panel yang diuji

Terpasang: `lcd_td4160_cw_old_mipi_hd` — MIPI-DSI 4 lane, pixel clock 168 MHz,
720×1600 HD+ (~6.74 inci), refresh 60/90 Hz, backlight 4095 langkah tanpa HBM,
ESD check register 0x0A tiap 2 detik. Panel ini tidak punya jalur HDR maupun gamut
lebar; mode warnanya sRGB saja.

Firmware uji: RMX3760export_15_H.05 (Android 15). Mode warna tersedia dalam pilihan
Alami dan Menyala, masing-masing dengan suhu Default/Hangat/Dingin, tersimpan di
`display_color_mode` dan `sprd_display_color_temperature_mode`.

## Instalasi

Flash zip dari halaman release lewat Magisk, reboot, lalu cek log:

```
/data/adb/lcd_max_td4160.log
```

Modul mengenali panel tempat ia dipasang. Bila nama panel berbeda dari yang diuji,
installer memberi tahu tapi tetap lanjut — skrip aman karena setiap penulisan dicek
dulu ketersediaannya.

## Mengadaptasi ke panel OEM lain

Ganti layar dengan IC berbeda? Urutan kerjanya singkat:

1. Baca nama panel baru dari `/sys/.../panel0/name`.
2. Lihat kalibrasi yang disiapkan firmware untuk panel itu di `/vendor/etc/enhance/`.
3. Pastikan node runtime (`cabc_private`, rentang backlight) masih ada — skrip sudah
   otomatis melewati yang tidak ada.
4. Verifikasi pipeline digital dengan membandingkan nilai piksel screenshot terhadap
   warna sumber sebelum menyimpulkan masalah ada di panel.
