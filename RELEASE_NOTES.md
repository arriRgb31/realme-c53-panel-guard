Panel Guard v1.0 — rilis perdana, diuji pada panel LCD bukan pabrik merek BraderParts
untuk Realme C53/C50.

Yang ada di dalamnya:

- Penjaga CABC: memastikan fitur peredup otomatis layar tetap mati dan mengeceknya
  ulang setiap dua menit, karena firmware kadang menyalakannya kembali diam-diam.
- Lantai performa DPU 384 MHz dengan governor performance supaya animasi jarang
  menampilkan frame basah.
- Pencatat keputusan firmware ke log: mode warna (Alami/Menyala), suhu warna,
  status kalibrasi warna, dan refresh rate aktif — dibaca dari state resmi sistem,
  bukan hasil pemindaian file.

Tidak termasuk, dan memang tidak akan: penguncian refresh rate, perubahan partisi
atau boot image, serta paksaan HDR/gamut lebar yang mustahil secara fisik panel.

File: realme-c53-panel-guard_v1.0.zip — flash via Magisk, reboot, selesai.
