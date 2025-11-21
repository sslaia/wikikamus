# wikikamus

Sebuah aplikasi untuk menampilkan isi **Wikikamus bahasa daerah di Indonesia**, termasuk kemungkinan untuk menyunting dan menciptakan halaman baru.

## Versi 1.0.0

Melalui Pengaturan pengguna bisa mengatur:
- Bahasa, yang akan menjadi bahasa item menu dan pesan-pesan serta situs Wikikamus bahasa ybs. Mis. memilih bahasa Madura, akan menampilkan menu dalam bahasa Madura dan semua konten berasal dari situs mad.wiktionary.org
- Mode gelap terang.
- Besar ukuran huruf
- Mencari isi kamus

## Keterbatasan

Aplikasi ini masih membutuhkan banyak kerja untuk **menyesuaikan berbagai tampilan halaman utama Wikikamus** ke layar aplikasi, bukan hanya menyangkut layout, melainkan juga seksi-seksi yang perlu dan tidak perlu ditampilkan (yang biasa disebut nomobile di css styles)

Dan karena ada 11 situs yang diikutkan dalam aplikasi ini, maka pekerjaan tsb. di atas menjadi 11 kali lebih banyak!

Seandainya semua situs Wikikamus di Indonesia mengikuti aturan yang sama untuk css styles dan pembagian seksi di situs, maka kerja tsb. hanya dibuat sekali jadi dan akan berjalan untuk semua situs.

## Rencana untuk versi-versi berikutnya

Yang perlu dikerjakan untuk versi-versi berikutnya:
- Memoles tampilan halaman utama setiap bahasa daerah 
Saat ini tidak diproses apa pun, jadi tampilan bisa kacau, tergantung style css yang digunakan
- Memperbaiki _rendering_ aksara bahasa daerah
- Memperbaiki penganganan pranala wiki
- Memungkinkan pengguna mereset pembaharuan konten halaman 
Sekarang ini konten halaman diunduh sekali seminggu
- Memperbaiki penanganan audio pengucapan
- Memperpaiki penanganan gambar
- Masuk ke dalam dengan akun Wikimedia pengguna sendiri (hal ini perlu bila pengguna ingin menyunting dan membuat halaman baru)
- Menyunting dan membuat halaman baru

## Ingin membantu memperbaiki?

Repository aplikasi ini terdapat di [https://github.com/sslaia/wikikamus](https://github.com/sslaia/wikikamus)

Silakan mengkontribusi kode perbaikan di sana, terutama untuk perbaikan tampilan dan konten situs bahasa daerah Anda sendiri.

