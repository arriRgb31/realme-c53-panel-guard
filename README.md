# Panel Guard — Realme C53 / C50

Modul Magisk **runtime-only** untuk **layar OEM (bukan original)** di
Realme C53 (RMX3760) / C50. Diuji pada panel `lcd_td4160_cw_old_mipi_hd`.

> Gw bikin ini awalnya buat layar HP gw sendiri yang suka memudar diam-diam.
> Tapi temuan risetnya berlaku buat siapa pun yang pakai LCD OEM di C53/C50 —
> makanya semuanya gw dokumentasikan publik di sini: gejalanya, penyebabnya,
> dan cara mengatasinya. Kalau panelmu beda tipe, panduan adaptasinya juga ada.

Layar OEM kadang memudar sendiri karena firmware mengaktifkan CABC
(penghemat daya panel) diam-diam. Panel Guard menjaga CABC tetap mati
dengan pengecekan cepat tiap 10 detik, menjaga DPU tetap gesit, dan
mencatat keputusan firmware ke log —

- tidak mengunci refresh rate, whitelist firmware berjalan utuh
- tidak menulis partisi atau boot image
- copot modul = semua kembali seperti semula

| Fitur | Detail |
|---|---|
| Penjaga CABC | cek `cabc_private` tiap 10 detik, re-apply bila dinyalakan firmware |
| DPU performance | lantai 384 MHz + governor performance |
| Pencatat firmware | mode warna (Alami/Menyala), suhu warna, status enhanceHAL & fps |

Kalibrasi warna bawaan (`enhanceHAL`) sengaja **tidak disentuh** — hasil uji
menunjukkan tanpa kalibrasi ini layar justru lebih pudar.

## Instalasi

```
Magisk → Modules → Install from storage → zip dari Releases → reboot
```

Log: `/data/adb/panel_guard.log`

## Untuk siapa modul ini

- Pengguna C53/C50 dengan LCD gantian service center / pasar yang layarnya
  suka pucat atau redup mendadak di konten putih
- Yang mau warna konsisten dan tidak keberatan kompromi baterai sedikit
- Yang penasaran kenapa layar "berperilaku aneh" — log modul ini merekam
  keputusan firmware secara langsung, jadi bisa dipakai belajar sekaligus

## Adaptasi panel OEM lain

Skrip otomatis melewati node yang tidak ada. Untuk panel berbeda:
cek nama panel via node `panel0/name`, cocokkan kalibrasi di
`/vendor/etc/enhance/`, lalu uji piksel screenshot vs warna sumber
sebelum menyalahkan panel.
