import 'package:admin_dokter_panggil/src/models/mr_kunjungan_penghentian_layanan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganPenghentianLayananRepo {
  Future<MrKunjunganPenghentianLayananModel> getPenghentian(
      int idKunjungan) async {
    final response = await dio.get('/v2/mr/penghentian-layanan/$idKunjungan');
    return mrKunjunganPenghentianLayananModelFromJson(response);
  }
}
