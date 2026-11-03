class Mahasiswa {
  final int? id;
  final String nim;
  final String nama;
  final String prodi;

  Mahasiswa({
    this.id,
    required this.nim,
    required this.nama,
    required this.prodi,
  });

  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      'nim': nim,
      'nama': nama,
      'prodi': prodi,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Mahasiswa.fromMap(Map<String, dynamic> map) {
    return Mahasiswa(
      id: map['id'] as int?,
      nim: map['nim'] as String,
      nama: map['nama'] as String,
      prodi: map['prodi'] as String,
    );
  }
}
