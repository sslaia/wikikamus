const whatsNew = '''
<h3>Baru di versi 1.0.0</h3>
<ul>
<li>Versi pertama Wikikamus. Hanya mencakup fungsi dasar saja.</li>
<li>Pengguna bisa memilih bahasa dari berbagai situs Wikikamus bahasa daerah di Indonesia.</li>
<li>Aplikasi akan menampilkan konten kamus dari bahasa terpilih,
namun item menu dan pesan-pesan masih dalam bahasa Indonesia, 
kecuali Wikikamus Nias, yang telah selesai diterjemahkan.</li>
<li>Pengguna bisa menetapkan ukuran besar huruf serta memilih tema mode gelap/terang.</li>
<li>Fungsi mencari isi kamus telah terintegrasi.</li>
</ul>

<p><strong>Catatan</strong></p>
<ul>
<li>Bila Anda mengakses kamus selain Wikikamus Nias,
bisa terjadi bahwa aplikasi butuh waktu lama memuat Halamn Utama ke layar.
Namun setelah selesai diunduh dan diproses, aplikasi bisa menampilkannya dengan cepat,
karena aplikasi akan menyimpan sementara Halaman Utama tsb. di perangkat
dan hanya membaharuinya sekali seminggu.</li>
<li>Hal ini tidak berlaku untuk halaman lema sendiri,
yang harus diunduh setiap kali supaya tetap aktual.
Jadi mohon sabar bila satu halaman butuh waktu lebih lama untuk tayang.</li>
<li>Sudah merupakan rahasia umum di antara para <em>developers</em>
bahwa kompleksitas kode wiki dengan penggunaan templat yang rumit
membuat susah mengoptimalkannya di layar aplikasi mobile.
Jadi bisa terjadi bahwa HU dan halaman lema juga tampil kurang optimal.
Saat ini hanya Wikikamus Nias yang telah dioptimalkan untuk mobile.</li>
<li>Aplikasi mengambil konten HU dari REST API Wikimedia 
dan konten yang disediakan tidak selalu persis sama dengan yang kita lihat dalam peramban.
Jadi bisa terjadi bahwa ada bagian yang "hilang".
Solusi untuk ini adalah membuat HU ramah mobile mengikuti
rekomendasi dari Wikimedia yang ditulis di 
<a href="https://www.mediawiki.org/wiki/Recommendations_for_mobile_friendly_articles_on_Wikimedia_wikis">sini</a></li>
</ul>

<h3>Rencana untuk versi-versi berikutnya</h3>
<ul>
<li>Memoles tampilan halaman utama setiap bahasa daerah. 
Saat ini belum diproses apa pun, jadi tampilan bisa kacau, tergantung style yang digunakan.</li>
<li>Menerjemahkan bahasa antar muka ke dalam berbagai bahasa daerah ybs. sehingga
semua item menu dan pesan-pesan akan tampil 
dalam bahasa yang dipilih.</li>
<li>Memperbaiki penanganan pranala wiki.</li>
<li>Memungkinkan pengguna mereset pembaharuan konten Halaman Utama (HU). 
Sekarang ini konten HU diunduh sekali seminggu.</li>
<li>Memperbaiki penanganan audio pengucapan.</li>
<li>Pengguna bisa masuk ke Wikimedia dengan akun Wikimedia mereka sendiri 
(hal ini perlu bila pengguna ingin menyunting serta membuat halaman baru di wiki).</li>
<li>Fungsi menyunting dan membuat halaman baru langsund di dalam aplikasi.</li>a
</ul>

<p>Repository aplikasi ini terdapat di <a href="https://github.com/sslaia/wikikamus">https://github.com/sslaia/wikikamus</a>.</p>
''';
