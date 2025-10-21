import 'package:admin_dokter_panggil/src/models/tambah_perawat_hapus_model.dart';
import 'package:admin_dokter_panggil/src/models/tambah_perawat_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TambahPerawatRepo {
  Future<TambahPerawatModel> tambahPerawat(
      TambahPerawatRequestModel tambahPerawatRequestModel,
      int idKunjungan) async {
    final response = await dio.post('/v2/mr/petugas/tambah/$idKunjungan',
        tambahPerawatRequestModelToJson(tambahPerawatRequestModel));
    return tambahPerawatModelFromJson(response);
  }

  Future<TambahPerawatHapusModel> hapusPerawat(int idKonfirmasiPerawat) async {
    final response =
        await dio.delete('/v2/mr/petugas/tambah/$idKonfirmasiPerawat');
    return tambahPerawatHapusModelFromJson(response);
  }
}
