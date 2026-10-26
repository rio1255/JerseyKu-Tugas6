## Kontribusi Hendrikus de Ornay

NIM: 23083000142

### Dokumentasi Pengujian Basis Data

Mendokumentasikan pengujian integritas basis data JerseyKu, meliputi INSERT valid, penolakan INSERT dengan foreign key tidak valid, pengujian DELETE data induk, dan JOIN antar tabel.

Hasil pengujian dicatat dalam README sebagai dokumentasi proses verifikasi basis data.

## Kontribusi Fransisco A F Pede

NIM: 23083000022

### Pengujian Integritas Foreign Key

Pengujian dilakukan dengan mencoba memasukkan data pesanan yang menggunakan referensi foreign key tidak valid.

**Hasil pengujian:** MySQL menolak perintah INSERT dengan error `#1452`. Hasil ini menunjukkan bahwa constraint foreign key mencegah penyimpanan data yang merujuk pada data induk yang tidak valid.

Pengujian ini merupakan bagian dari verifikasi integritas referensial pada basis data JerseyKu.
## Kontribusi Delpiero Falerio Wafom

NIM: 23083000134

### Pengujian JOIN Antar Tabel

Pengujian dilakukan untuk menggabungkan data pesanan dengan data pelanggan, desain jersey, dan template jersey menggunakan perintah `JOIN`.

**Hasil pengujian:** Query JOIN berhasil dijalankan dan menampilkan data pesanan beserta informasi pelanggan, desain, dan template jersey. Pengujian ini menunjukkan bahwa relasi antar tabel dapat digunakan untuk mengambil data yang saling berhubungan.

Pengujian JOIN merupakan bagian dari verifikasi relasi dan pengambilan data pada basis data JerseyKu.
