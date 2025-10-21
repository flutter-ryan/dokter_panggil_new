import 'package:admin_dokter_panggil/src/models/kunjungan_paket_update_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganPaketDeleteRepo {
  Future<ResponseKunjunganPaketUpdateModel> deletePaket(int idKunjungan) async {
    final response = await dio.delete('/v2/mr/daftar-paket/$idKunjungan');
    return responseKunjunganPaketUpdateModelFromJson(response);
  }
}
