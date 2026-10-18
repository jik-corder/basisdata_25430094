# Dokumentasi Normalisasi Skema Relasional Proyek Toko Baju

**Nama Organisasi / Toko:** Toko Baju Store_094  
**Nama Mahasiswa:** Abizar Gavra Andika  
**NPM:** 25430094  
**Kelas:** D Ilmu Komputer  
**Tema Proyek:** Toko Daring / E-Commerce Baju (Harga Fleksibel Rp30.000 - Rp100.000)  

---

## 1. Aturan Bisnis (AB) Proyek

- **AB-01:** Setiap transaksi penjualan memiliki nomor nota unik dan melayani satu atau banyak item baju.
- **AB-02:** Pembelian baju dapat dilakukan oleh pelanggan terdaftar atau pembeli umum (*guest*).
- **AB-03:** Stok baju tidak boleh bernilai negatif; transaksi penjualan akan ditolak jika jumlah beli melebihi stok gudang yang tersedia.
- **AB-04:** Harga baju bersifat fleksibel berkisar antara Rp30.000 hingga Rp100.000. Harga jual yang tercantum pada nota transaksi disimpan secara historis per baris item (*potret transaksi*) dan tidak akan berubah meskipun harga master baju mengalami pembaruan di masa depan.
- **AB-05:** Setiap petugas/kasir memiliki ID unik dan bertugas mencatat setiap transaksi penjualan yang dilayaninya.

---

## 2. Bentuk Tidak Normal (UNF)

Dokumen nota penjualan mentah yang dikumpulkan dari dokumen sumber (Pertemuan 2) masih mengandung kelompok berulang (*repeating group* di dalam kurung kurawal):

```text
NOTA_PENJUALAN_UNF (
    no_nota_penjualan, 
    tgl_penjualan, 
    id_petugas, 
    nama_petugas, 
    id_pelanggan, 
    nama_pelanggan, 
    { 
        id_barang, 
        nama_barang, 
        kategori_barang, 
        qty_penjualan, 
        harga_satuan_penjualan, 
        subtotal 
    }, 
    total_bayar
)
## 3. Bentuk Normal Pertama (1NF)

- **Syarat:** Menghilangkan kelompok berulang (*repeating group*) dengan cara meratakan baris sehingga setiap sel bernilai atomik.
- **Kunci Primer Komposit:** (`no_nota_penjualan`, `id_barang`)

```text
NOTA_PENJUALAN_1NF (
    no_nota_penjualan, 
    id_barang, 
    tgl_penjualan, 
    id_petugas, 
    nama_petugas, 
    id_pelanggan, 
    nama_pelanggan, 
    nama_barang, 
    kategori_barang, 
    qty_penjualan, 
    harga_satuan_penjualan, 
    subtotal, 
    total_bayar
)
---

## 4. Daftar Dependensi Fungsional (FD)

- **FD1:** `no_nota_penjualan -> tgl_penjualan, id_petugas, id_pelanggan` (AB-01)
- **FD2:** `id_petugas -> nama_petugas` (AB-05)
- **FD3:** `id_pelanggan -> nama_pelanggan` (AB-02)
- **FD4:** `id_barang -> nama_barang, kategori_barang, harga_jual_master` (AB-04)
- **FD5:** `(no_nota_penjualan, id_barang) -> qty_penjualan, harga_satuan_penjualan` (AB-04)
- **FD6:** `(qty_penjualan, harga_satuan_penjualan) -> subtotal` (Atribut Turunan)

---

## 5. Bentuk Normal Kedua (2NF)

Memisahkan ketergantungan parsial pada kunci primer komposit:

- **PENJUALAN** (`no_nota_penjualan`, `tgl_penjualan`, `id_petugas`, `nama_petugas`, `id_pelanggan`, `nama_pelanggan`)
- **DETAIL_PENJUALAN** (`no_nota_penjualan`, `id_barang`, `qty_penjualan`, `harga_satuan_penjualan`)
- **BARANG** (`id_barang`, `nama_barang`, `kategori_barang`, `harga_jual_master`)

---

## 6. Bentuk Normal Ketiga (3NF) & Pemeriksaan BCNF

Memisahkan ketergantungan transitif antar atribut non-kunci:

- **PETUGAS** (`id_petugas`, `nama_petugas`, `peran_petugas`)
- **PELANGGAN** (`id_pelanggan`, `nama_pelanggan`, `no_hp_pelanggan`)
- **BARANG** (`id_barang`, `nama_barang`, `kategori_barang`, `harga_jual_master`, `stok_barang`)
- **PENJUALAN** (`id_penjualan`, `no_nota_penjualan`, `tgl_penjualan`, `id_petugas`, `id_pelanggan`)
- **DETAIL_PENJUALAN** (`id_penjualan`, `id_barang`, `qty_penjualan`, `harga_satuan_penjualan`)

**Pemeriksaan BCNF:** Seluruh penentu (*determinant*) pada skema 3NF merupakan kunci kandidat, sehingga memenuhi syarat BCNF.

---

## 7. Keputusan Penyimpanan Nilai Turunan

- **Keputusan:** Nilai turunan seperti `subtotal` dan `total_bayar` **TIDAK DISIMPAN** pada tabel operasional database `store_094`.
- **Alasan:** Dihitung secara dinamis menggunakan kueri SQL (`SUM(qty * harga)`) untuk menjaga integritas dan menghindari anomali data.

---

## 8. Ringkasan Skema Relasional Akhir

| Nama Tabel | Kunci Primer (PK) | Kunci Unik (UQ) | Kunci Tamu (FK) |
| :--- | :--- | :--- | :--- |
| `petugas` | `id_petugas` | `kode_petugas` | - |
| `pelanggan` | `id_pelanggan` | `no_pelanggan` | - |
| `barang` | `id_barang` | `kode_barang` | - |
| `penjualan` | `id_penjualan` | `no_nota_penjualan` | `id_petugas`, `id_pelanggan` |
| `detail_penjualan` | (`id_penjualan`, `id_barang`) | - | `id_penjualan`, `id_barang` |

---

## 9. Catatan Pembaruan ERD Proyek

- ERD diperbarui dari bentuk awal Modul 2 menjadi struktur 5 tabel normalisasi 3NF/BCNF.
- Penambahan entitas asosiatif `detail_penjualan` untuk menangani relasi *many-to-many* antara `penjualan` dan `barang`.

---

## 10. Pernyataan Keaslian

Dokumen normalisasi ini disusun secara mandiri oleh Abizar Gavra Andika (25430094) sebagai bagian dari Milestone Proyek Praktikum Basis Data Pertemuan 04.