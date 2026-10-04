# Dokumen Kebutuhan Data - Proyek Toko Daring (Store 094)

**NIM:** 25430094  
**Nama Organisasi Fiktif:** Toko Daring Store 094  
**Tanggal:** 4 Oktober 2026  

---

## 1. Parameter Personal Berbasis NIM (Perhitungan P)

Sesuai ketentuan Modul 2:
- **Dua digit terakhir NIM:** 94
- **Perhitungan $P$:** $(94 \bmod 9) + 1 = 4 + 1 = 5$

**Nilai Parameter Terhitung:**
- **Batas Maksimal Item per Transaksi:** $P + 2 = 5 + 2 = 7$ item
- **Persentase Diskon Harian:** $P = 5\%$
- **Perkiraan Volume Transaksi Harian:** $40 + (5 \times 5) = 65$ transaksi/hari

---

## 2. Proses Bisnis Utama (Minimal 4)

1. **PB-01: Pendaftaran dan Pengelolaan Profil Pelanggan**  
   Pelanggan mendaftarkan akun baru dengan memberikan data pribadi (nama, email, nomor HP, dan alamat pengiriman).
2. **PB-02: Manajemen Katalog Produk**  
   Admin mengelola data kategori dan produk, termasuk memperbarui harga, stok, serta rincian deskripsi barang.
3. **PB-03: Pemrosesan Pesanan dan Pembayaran**  
   Pelanggan memilih produk, melakukan checkout (maksimal 7 item per transaksi), memilih metode pembayaran, dan melakukan pembayaran.
4. **PB-04: Pengiriman dan Pelacakan Pesanan**  
   Sistem menerbitkan resi pengiriman, lalu staf gudang memperbarui status pengiriman barang hingga diterima oleh pelanggan.

---

## 3. Entitas Kandidat (Minimal 6)

1. **`Pelanggan`**: Menyimpan informasi identitas dan kontak pengguna.
2. **`Kategori`**: Menyimpan kelompok/kategori barang.
3. **`Produk`**: Menyimpan rincian barang, harga, dan stok.
4. **`Pesanan`**: Menyimpan header transaksi pesanan, tanggal, total bayar, dan status.
5. **`Item_Pesanan`**: Menyimpan rincian item barang yang dibeli pada setiap pesanan.
6. **`Pembayaran`**: Menyimpan bukti dan riwayat pembayaran transaksi.

---

## 4. Aturan Bisnis (Minimal 8)

1. **AB-01**: Setiap pelanggan harus memiliki email dan nomor HP yang unik.
2. **AB-02**: Setiap pesanan maksimal hanya boleh berisi **7 item produk yang berbeda** (sesuai parameter $P+2$).
3. **AB-03**: Harga barang, ongkos kirim, dan alamat pengiriman yang dicatat pada pesanan bersifat **permanen** (dikunci sesuai harga saat transaksi terjadi).
4. **AB-04**: Pesanan yang belum dibayar dalam waktu $24$ jam akan dibatalkan secara otomatis oleh sistem.
5. **AB-05**: Setiap pembayaran harus terverifikasi sebelum status pesanan diubah menjadi `Diproses`.
6. **AB-06**: Diskon promosi harian yang diterapkan maksimal sebesar **$5\%$** (sesuai parameter $P$).
7. **AB-07**: Stok produk akan berkurang secara otomatis saat pesanan dikonfirmasi.
8. **AB-08**: Sistem dirancang untuk mampu menangani minimal **65 volume transaksi harian** (sesuai parameter volume transaksi).

---

## 5. Kebutuhan Informasi (Minimal 5)

1. **KI-01**: Laporan rekapitulasi penjualan harian dan bulanan.
2. **KI-02**: Daftar produk terlaris (*best-seller*) berdasarkan jumlah item yang terjual.
3. **KI-03**: Riwayat riwayat transaksi dan status pengiriman per pelanggan.
4. **KI-04**: Laporan sisa stok produk yang mendekati batas minimum (peringatan restock).
5. **KI-05**: Bukti transaksi (Nota Pembayaran) digital untuk pelanggan.

---

## 6. Matriks CRUD Complete

| Entitas | Create | Read | Update | Delete | Alasan/Keterangan |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Pelanggan** | v | v | v | v | Akun didaftarkan, dilihat profilnya, diubah datanya, atau dihapus atas permintaan. |
| **Kategori** | v | v | v | v | Dikelola penuh oleh Admin Toko. |
| **Produk** | v | v | v | v | Dikelola penuh oleh Admin Toko. |
| **Pesanan** | v | v | v | x | Pesanan tidak pernah dihapus (*Delete*) demi integritas data keuangan & riwayat audit. Status hanya diubah menjadi `Canceled`. |
| **Item_Pesanan**| v | v | v | x | Rincian pesanan tidak dihapus untuk menjaga riwayat transaksi. |
| **Pembayaran** | v | v | v | x | Data transaksi keuangan bersifat permanen dan tidak boleh dihapus. |

---

## 7. Kamus Data Awal (20 Elemen Data)

| No | Nama Elemen Data | Entitas | Tipe Data | Keterangan / Deskripsi | Penanggung Jawab |
| :-: | :--- | :--- | :--- | :--- | :--- |
| 1 | `id_pelanggan` | Pelanggan | INT | ID unik pelanggan (Primary Key) | DBA / Backend Dev |
| 2 | `nama_lengkap` | Pelanggan | VARCHAR(100) | Nama lengkap pelanggan | Tim Registrasi |
| 3 | `email` | Pelanggan | VARCHAR(100) | Alamat email pelanggan | Tim Registrasi |
| 4 | `no_hp` | Pelanggan | VARCHAR(20) | Nomor WhatsApp/Telepon | Tim Registrasi |
| 5 | `alamat` | Pelanggan | TEXT | Alamat domisili/pengiriman | Tim Registrasi |
| 6 | `id_kategori` | Kategori | INT | ID unik kategori produk | Admin Katalog |
| 7 | `nama_kategori` | Kategori | VARCHAR(50) | Nama kelompok barang | Admin Katalog |
| 8 | `id_produk` | Produk | INT | ID unik produk | Admin Katalog |
| 9 | `nama_produk` | Produk | VARCHAR(150) | Nama item barang | Admin Katalog |
| 10 | `harga_produk` | Produk | DECIMAL(10,2) | Harga master produk saat ini | Admin Katalog |
| 11 | `stok` | Produk | INT | Jumlah stok tersedia | Staf Gudang |
| 12 | `id_pesanan` | Pesanan | INT | ID unik transaksi pesanan | System Checkout |
| 13 | `tgl_pesanan` | Pesanan | DATETIME | Waktu transaksi dibuat | System Checkout |
| 14 | `total_bayar` | Pesanan | DECIMAL(12,2) | Total harga akhir pesanan | System Checkout |
| 15 | `status_pesanan` | Pesanan | VARCHAR(30) | Status (Pending/Lunas/Kirim)| System Checkout |
| 16 | `jumlah_item` | Item_Pesanan | INT | Quantitas barang dibeli | System Checkout |
| 17 | `harga_satuan` | Item_Pesanan | DECIMAL(10,2) | Harga produk saat transaksi | System Checkout |
| 18 | `id_pembayaran` | Pembayaran | INT | ID unik transaksi bayar | Tim Keuangan |
| 19 | `metode_bayar` | Pembayaran | VARCHAR(50) | Transfer/E-Wallet/Credit | Tim Keuangan |
| 20 | `no_resi` | Pengiriman | VARCHAR(50) | Nomor resi ekspedisi | Staf Pengiriman |

---

## 8. Kebutuhan Non-Fungsional & Identifikasi Data Pribadi

### Kebutuhan Non-Fungsional:
* **Keamanan Data**: Seluruh kata sandi pengguna wajib dienkripsi menggunakan algoritma *hash* (seperti Bcrypt).
* **Ketersediaan (*Availability*)**: Sistem harus dapat diakses $99.9\%$ waktu operasional.

### Identifikasi Data Pribadi (PII - Personally Identifiable Information):
1. **Data Sensitif/Pribadi**:
   - Nama Lengkap Pelanggan
   - Nomor Handphone
   - Alamat Email
   - Alamat Pengiriman Lengkap
2. **Aturan Hak Akses (Privilege)**:
   - **Pelanggan**: Hanya bisa melihat dan mengubah data pribadinya sendiri.
   - **Staf Pengiriman**: Hanya bisa melihat nama, nomor HP, dan alamat tujuan pengiriman pesanan yang sedang diproses.
   - **Admin / DBA**: Memiliki akses teknis dengan pengawasan ketat, namun data sensitif seperti password terenkripsi.

---

## 9. Dokumen Sumber Fiktif dan Pembedahannya

### Dokumen Sumber: **Nota Pesanan Digital (Invoice)**

```text
====================================================================
                        STORE 094 - NOTA PESANAN
====================================================================
No. Pesanan : INV-20261004-094           Tanggal : 04/10/2026
Pelanggan   : Abizar Gavra Andika        No. HP  : 081234567890
Alamat      : Jl. Mawar No. 12, Bandar Lampung
--------------------------------------------------------------------
No  Nama Produk                Harga Satuan   Qty   Subtotal (Rp)
--------------------------------------------------------------------
1   Kemeja Casual Size L       Rp 150.000       2   Rp 300.000
2   Celana Chino Hitam 32      Rp 200.000       1   Rp 200.000
--------------------------------------------------------------------
Subtotal Produk : Rp 500.000
Diskon Promosi  : Rp  25.000 (5%)
Ongkos Kirim    : Rp  20.000
--------------------------------------------------------------------
TOTAL BAYAR     : Rp 495.000
====================================================================