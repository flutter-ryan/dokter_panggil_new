import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pengkajian_perawat_model.dart';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_perawat_anak_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrPengkajianPerawatRepo {
  Future<MrKunjunganPengkajianPerawatModel> getPengkajianPerawat(
      int idKunjungan) async {
    final response = await dio.get('/v2/mr/pengkajian-perawat/$idKunjungan');
    return mrKunjunganPengkajianPerawatModelFromJson(response);
  }

  Future<MrPengkajianPerawatAnakModel> getPengkajianPerawatAnak(
      int idKunjungan) async {
    final response = await dio.get('/v2/mr/pengkajian-perawat/$idKunjungan');
    return mrPengkajianPerawatAnakModelFromJson(response);
  }
}
