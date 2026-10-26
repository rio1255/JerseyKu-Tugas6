# JerseyKu-Tugas6

Implementasi Basis Data Final Sistem Pemesanan Jersey Custom.

## Anggota Kelompok

1. Hendrikus de Ornay — 23083000142
2. Fransisco A F Pede — 23083000022
3. Delpiero Falerio Wafom — 23083000134

## Dokumentasi Pengujian Basis Data

### 1. Pengujian INSERT Valid

Pengujian dilakukan dengan menambahkan data pemain ke tabel `detail_pemain` menggunakan `id_pesanan` yang valid.

Perintah SQL:

```sql
INSERT INTO detail_pemain
(id_pesanan, nama_punggung, no_punggung, ukuran)
VALUES (1, 'UJI', 99, 'L');
```

**Hasil:** INSERT berhasil dijalankan dan data baru berhasil ditambahkan ke tabel `detail_pemain`.

### 2. Pengujian Foreign Key Tidak Valid

Pengujian dilakukan dengan mencoba memasukkan data pesanan yang memiliki referensi foreign key tidak valid.

**Hasil:** MySQL menolak INSERT dengan error `#1452`. Error ini menunjukkan bahwa nilai foreign key tidak merujuk pada data induk yang valid.

### 3. Pengujian DELETE Data Induk

Pengujian penghapusan data pesanan dilakukan menggunakan perintah:

```sql
DELETE FROM pesanan WHERE id_pesanan = 1;
```

**Hasil:** Penghapusan berhasil dilakukan. Hasil ini menunjukkan bahwa penghapusan diizinkan oleh aturan relasi yang berlaku pada database. Pengujian ini tidak membuktikan bahwa constraint `RESTRICT` mencegah penghapusan.

### 4. Pengujian JOIN Antar Tabel

Pengujian JOIN dilakukan untuk menggabungkan informasi pesanan, pelanggan, desain jersey, dan template jersey.

Perintah SQL:

```sql
SELECT
    p.id_pesanan,
    u.nama AS nama_pelanggan,
    d.nama_tim,
    t.nama_template,
    p.jumlah_total,
    p.total_harga,
    p.status
FROM pesanan p
JOIN pengguna u ON p.id_pelanggan = u.id_pengguna
JOIN desain d ON p.id_desain = d.id_desain
JOIN template_jersey t ON d.id_template = t.id_template
ORDER BY p.id_pesanan;
```

**Hasil:** Query JOIN berhasil dijalankan dan menghasilkan 4 baris data pada saat pengujian.

## Catatan Pengujian

Dokumentasi ini mencatat hasil pengujian yang telah dilakukan. Pengujian constraint `UNIQUE` dan `NOT NULL` belum dicantumkan sebagai pengujian berhasil karena hasilnya belum terkonfirmasi.

## Pembagian Kontribusi

- **Hendrikus de Ornay:** Dokumentasi validasi dan constraint basis data.
- **Fransisco A F Pede:** Dokumentasi pengujian INSERT dan foreign key.
- **Delpiero Falerio Wafom:** Dokumentasi pengujian JOIN dan pemeriksaan hasil akhir basis data.

## Struktur Repository

- `JerseyKu_Tugas6.sql` — Skrip SQL untuk pembuatan dan pengisian tabel basis data.
- `Laporan_Tugas6_JerseyKu_Lengkap (1).docx` — Laporan Tugas 6.
- `README.md` — Dokumentasi proyek dan hasil pengujian basis data.
