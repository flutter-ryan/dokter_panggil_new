import 'package:admin_dokter_panggil/src/models/mr_kunjungan_anastesi_bedah_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganBedahAnastesiRepo {
  Future<MrKunjunganAnastesiBedahModel> getAnastesiBedah(
      int idKunjungan) async {
    final response =
        await dio.get('/v2/mr/tindakan-anastesi-bedah/$idKunjungan');
    return mrKunjunganAnastesiBedahModelFromJson(response);
  }
}
