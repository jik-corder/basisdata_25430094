# Milestone Proyek 4: Normalisasi Basis Data Proyek Toko Daring
**Nama:** Abizar Gavra Andika  
**NPM:** 25430094  
**Basis Data:** store_094  

---

## 1. Dokumen Sumber dan Skema Bentuk Tidak Normal (UNF)
Titik awal analisis normalisasi diambil dari dokumen transaksi digital berupa **Faktur / Invoice Pesanan Toko Daring** (turunan dokumen kebutuhan Pertemuan 2). Pada dokumen mentah ini, satu faktur pesanan menampung rincian beberapa produk sekaligus sehingga membentuk kelompok berulang (*repeating groups*).

### A. Format Faktur Mentah (Dokumen Sumber)
```text
Nomor Faktur   : FK-20261019-01
Tanggal Pesanan: 2026-10-19
ID Petugas     : PET01
Nama Petugas   : Abizar Gavra
-------------------------------------------------------------------------------------
Kode Barang | Nama Barang    | Harga Satuan | Stok | Jumlah Beli | Subtotal
-------------------------------------------------------------------------------------
BRG01       | Kemeja Flannel | Rp 150.000   | 20   | 2           | Rp 300.000
BRG02       | Celana Jeans   | Rp 250.000   | 15   | 1           | Rp 250.000
-------------------------------------------------------------------------------------
Total Pembayaran : Rp 550.000
```
### B. Notasi Skema Relasi UNF
```text
Faktur_UNF (
    no_faktur,
    tanggal,
    id_petugas,
    nama_petugas,
    daftar_barang(kode_barang, nama_barang, harga, stok, jumlah, subtotal),
    total_bayar
)
```
### C. Simulasi Tabel UNF
| no_faktur | tanggal | id_petugas | nama_petugas | daftar_barang | total_bayar |
| :--- | :--- | :--- | :--- | :--- | :--- |
| FK-20261019-01 | 2026-10-19 | PET01 | Abizar Gavra | BRG01 (Kemeja Flannel, 150000, 20, 2, 300000), BRG02 (Celana Jeans, 250000, 15, 1, 250000) | 550000 |
| FK-20261019-02 | 2026-10-19 | PET02 | Budi Santoso | BRG01 (Kemeja Flannel, 150000, 20, 1, 150000) | 150000 |
---

## 2. Dependensi Fungsional dan Aturan Bisnis (AB)
Ketergantungan fungsional (*Functional Dependency*) didefinisikan berdasarkan aturan bisnis sistem Toko Daring `store_094`:

- **AB01 (Identitas Petugas):**  
  Setiap petugas kasir/admin memiliki pengenal unik berupa `id_petugas` yang secara tunggal menentukan nama petugas.  
  $$\text{id\_petugas} \rightarrow \text{nama\_petugas}$$

- **AB02 (Katalog Barang):**  
  Setiap barang dagangan diidentifikasi secara unik oleh `kode_barang` yang menentukan deskripsi nama barang, harga katalog, dan sisa stok fisik.  
  $$\text{kode\_barang} \rightarrow \text{nama\_barang}, \text{harga}, \text{stok}$$

- **AB03 (Header Transaksi Penjualan):**  
  Setiap transaksi pesanan diidentifikasi secara unik oleh `no_faktur` yang menentukan tanggal terjadinya transaksi dan petugas yang melayani.  
  $$\text{no\_faktur} \rightarrow \text{tanggal}, \text{id\_petugas}$$

- **AB04 (Rincian Item Pembelian):**  
  Banyaknya barang yang dipesan dan nilai subtotal transaksi pada nota ditentukan secara bersama-sama oleh kombinasi nomor faktur dan barang tertentu.  
  $$\{\text{no\_faktur}, \text{kode\_barang}\} \rightarrow \text{jumlah}, \text{subtotal}$$

---

## 3. Tahapan Normalisasi (1NF, 2NF, 3NF, BCNF)

### A. Tahap Bentuk Normal Pertama (1NF)
- **Syarat:** Setiap kolom harus bernilai skalar/atomik (tidak ada atribut bernilai banyak/kumpulan teks dipisah koma), dan tidak ada perulangan kolom sejenis.
- **Tindakan:** Mengurai kelompok berulang `daftar_barang` menjadi baris-baris individual sehingga setiap baris hanya merepresentasikan satu jenis barang yang dibeli per faktur. Kunci utama gabungan komposit adalah $\{\text{no\_faktur}, \text{kode\_barang}\}$.

| no_faktur | tanggal | id_petugas | nama_petugas | kode_barang | nama_barang | harga | stok | jumlah | subtotal |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| FK-20261019-01 | 2026-10-19 | PET01 | Abizar Gavra | BRG01 | Kemeja Flannel | 150000 | 20 | 2 | 300000 |
| FK-20261019-01 | 2026-10-19 | PET01 | Abizar Gavra | BRG02 | Celana Jeans | 250000 | 15 | 1 | 250000 |
| FK-20261019-02 | 2026-10-19 | PET02 | Budi Santoso | BRG01 | Kemeja Flannel | 150000 | 20 | 1 | 150000 |

---

### B. Tahap Bentuk Normal Kedua (2NF)
- **Syarat:** Memenuhi 1NF dan tidak boleh ada ketergantungan parsial (*partial functional dependency*). Semua atribut non-kunci harus bergantung sepenuhnya (*full functional dependency*) pada keseluruhan *Primary Key*, bukan hanya sebagian elemen kunci komposit.
- **Analisis Pelanggaran pada 1NF:**  
  Kunci komposit adalah $\{\text{no\_faktur}, \text{kode\_barang}\}$.
  * Atribut `nama_barang`, `harga`, dan `stok` hanya bergantung pada $\text{kode\_barang}$ (bergantung parsial).
  * Atribut `tanggal`, `id_petugas`, dan `nama_petugas` hanya bergantung pada $\text{no\_faktur}$ (bergantung parsial).
- **Solusi Dekomposisi:**  
  Memecah relasi menjadi tiga tabel awal: tabel pesanan header, tabel katalog master barang, dan tabel detail transaksi.

#### 1. Tabel Penjualan_Header (Kunci: no_faktur)
| no_faktur (PK) | tanggal | id_petugas | nama_petugas |
| :--- | :--- | :--- | :--- |
| FK-20261019-01 | 2026-10-19 | PET01 | Abizar Gavra |
| FK-20261019-02 | 2026-10-19 | PET02 | Budi Santoso |

#### 2. Tabel Master Barang (Kunci: kode_barang)
| kode_barang (PK) | nama_barang | harga | stok |
| :--- | :--- | :--- | :--- |
| BRG01 | Kemeja Flannel | 150000 | 20 |
| BRG02 | Celana Jeans | 250000 | 15 |

#### 3. Tabel Detail Penjualan (Kunci: no_faktur, kode_barang)
| no_faktur (PK, FK) | kode_barang (PK, FK) | jumlah | subtotal |
| :--- | :--- | :--- | :--- |
| FK-20261019-01 | BRG01 | 2 | 300000 |
| FK-20261019-01 | BRG02 | 1 | 250000 |
| FK-20261019-02 | BRG01 | 1 | 150000 |

---

### C. Tahap Bentuk Normal Ketiga (3NF)
- **Syarat:** Memenuhi 2NF dan tidak boleh ada ketergantungan transitif (*transitive functional dependency*). Atribut non-kunci tidak boleh bergantung pada atribut non-kunci lainnya.
- **Analisis Pelanggaran pada 2NF:**  
  Pada tabel `Penjualan_Header`:  
  $$\text{no\_faktur} \rightarrow \text{id\_petugas} \rightarrow \text{nama\_petugas}$$  
  Atribut `nama_petugas` bergantung fungsional pada atribut non-kunci `id_petugas`. Ini menimbulkan anomali pembaruan jika nama petugas diubah.
- **Solusi Dekomposisi:**  
  Memisahkan entitas data petugas ke dalam tabel tersendiri (`petugas`), sehingga tabel `penjualan` hanya menyimpan `id_petugas` sebagai *Foreign Key*.

#### Struktur Skema Akhir 4 Entitas 3NF (Database `store_094`):
1. **`barang`**  
   * Skema: `barang(kode_barang, nama_barang, harga, stok)`  
   * PK: `kode_barang`
2. **`petugas`**  
   * Skema: `petugas(id_petugas, nama_petugas)`  
   * PK: `id_petugas`
3. **`penjualan`**  
   * Skema: `penjualan(no_faktur, tanggal, id_petugas)`  
   * PK: `no_faktur` | FK: `id_petugas` $\rightarrow$ `petugas(id_petugas)`
4. **`detail_penjualan`**  
   * Skema: `detail_penjualan(no_faktur, kode_barang, jumlah, subtotal)`  
   * PK Komposit: `(no_faktur, kode_barang)` | FK: `no_faktur`, `kode_barang`

---

### D. Pemeriksaan Bentuk Normal Boyce-Codd (BCNF)
- **Definisi:** Sebuah relasi berada dalam BCNF jika dan hanya jika untuk setiap ketergantungan fungsional nontrivial $X \rightarrow Y$, maka $X$ harus merupakan *superkey* (atau kandidat kunci).
- **Pengujian Relasi:**
  1. Relasi `barang`: Determinan adalah `kode_barang` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  2. Relasi `petugas`: Determinan adalah `id_petugas` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  3. Relasi `penjualan`: Determinan adalah `no_faktur` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  4. Relasi `detail_penjualan`: Determinan adalah pasangan komposit $\{\text{no\_faktur}, \text{kode\_barang}\}$ (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
- **Kesimpulan:** Tidak ada determinan tersembunyi yang bukan kandidat kunci. Seluruh skema database `store_094` berada dalam kondisi **3NF dan BCNF**.
---

## 4. Analisis Nilai Turunan (Derived Attributes)
Keputusan arsitektur mengenai penyimpanan atribut komputasi/turunan:

1. **Subtotal Pembelian (`jumlah * harga`):**
   * **Keputusan:** **Tetap Disimpan secara fisik** pada `detail_penjualan`.
   * **Alasan:** Menyimpan nilai subtotal transaksi berguna sebagai rekaman historis (*point-in-time snapshot*) agar ketika terjadi perubahan nilai harga barang di tabel `barang` di masa mendatang, rekaman nilai historis nota penjualan yang pernah terjadi tidak ikut berubah.

2. **Harga Barang (`harga` pada `barang`):**
   * **Keputusan:** **Tetap Disimpan secara fisik**.
   * **Alasan:** Merupakan atribut harga katalog produk aktif saat ini di tabel master.

---

## 5. Status Perubahan ERD Proyek
Berdasarkan hasil pengujian normalisasi, struktur 4 entitas yang dirancang untuk database `store_094` (`barang`, `petugas`, `penjualan`, dan `detail_penjualan`) telah terbukti bersih dari anomali redundansi, dependensi parsial, dan dependensi transitif.

- **Dekomposisi Lanjutan:** Tidak diperlukan tabel tambahan.
- **Status Berkas ERD:** Diagram konseptual dan fisik tetap valid dan digunakan sebagai acuan baku tanpa perubahan skema.
---

## 4. Pemeriksaan Bentuk Normal Boyce-Codd (BCNF)

- **Definisi:** Sebuah relasi berada dalam BCNF jika dan hanya jika untuk setiap ketergantungan fungsional nontrivial $X \rightarrow Y$, maka $X$ harus merupakan *superkey* (atau kandidat kunci).

- **Pengujian Relasi:**
  1. Relasi `barang`: Determinan adalah `kode_barang` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  2. Relasi `petugas`: Determinan adalah `id_petugas` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  3. Relasi `penjualan`: Determinan adalah `no_faktur` (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.
  4. Relasi `detail_penjualan`: Determinan adalah pasangan komposit $\{\text{no\_faktur}, \text{kode\_barang}\}$ (merupakan Primary Key / Superkey). $\rightarrow$ **Lolos BCNF**.

- **Kesimpulan:** Tidak ada determinan tersembunyi yang bukan kandidat kunci. Seluruh skema database `store_094` berada dalam kondisi **3NF dan BCNF**.
## 5. Analisis Nilai Turunan (Derived Attributes)
Keputusan arsitektur mengenai penyimpanan atribut komputasi/turunan:

1. **Subtotal Pembelian (`jumlah * harga`):**
   * **Keputusan:** **Tetap Disimpan secara fisik** pada `detail_penjualan`.
   * **Alasan:** Menyimpan nilai subtotal transaksi berguna sebagai rekaman historis (*point-in-time snapshot*) agar ketika terjadi perubahan nilai harga barang di tabel `barang` di masa mendatang, rekaman nilai historis nota penjualan yang pernah terjadi tidak ikut berubah.

2. **Harga Barang (`harga` pada `barang`):**
   * **Keputusan:** **Tetap Disimpan secara fisik**.
   * **Alasan:** Merupakan atribut harga katalog produk aktif saat ini di tabel master.

---

## 6. Status Perubahan ERD Proyek
Berdasarkan hasil pengujian normalisasi, struktur 4 entitas yang dirancang untuk database `store_094` (`barang`, `petugas`, `penjualan`, dan `detail_penjualan`) telah terbukti bersih dari anomali redundansi, dependensi parsial, dan dependensi transitif.

- **Dekomposisi Lanjutan:** Tidak diperlukan tabel tambahan.
- **Status Berkas ERD:** Diagram konseptual dan fisik tetap valid dan digunakan sebagai acuan baku tanpa perubahan skema.