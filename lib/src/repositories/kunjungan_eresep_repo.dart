import 'package:admin_dokter_panggil/src/models/kunjungan_eresep_create_model.dart';
import 'package:admin_dokter_panggil/src/models/kunjungan_eresep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganEresepRepo {
  Future<KunjunganEresepModel> getEresep(int id) async {
    final response = await dio.get('/v1/layanan-kunjungan/e-resep/$id');
    return kunjunganEresepModelFromJson(response);
  }

  Future<KunjunganEresepModel> getEresepNon(int id) async {
    final response = await dio.get('/v1/layanan-kunjungan/e-resep-non/$id');
    return kunjunganEresepModelFromJson(response);
  }

  Future<KunjunganEresepModel> getEresepBaru(
      KunjunganEresepCreateModel kunjunganEresepCreateModel) async {
    final response = await dio.post('/v1/layanan-kunjungan/e-resep-baru',
        kunjunganEresepCreateModelToJson(kunjunganEresepCreateModel));
    return kunjunganEresepModelFromJson(response);
  }

  Future<KunjunganEresepModel> getEresepRacikanBaru(
      KunjunganEresepCreateModel kunjunganEresepCreateModel) async {
    final response = await dio.post(
        '/v1/layanan-kunjungan/e-resep-racikan-baru',
        kunjunganEresepCreateModelToJson(kunjunganEresepCreateModel));
    return kunjunganEresepModelFromJson(response);
  }
}
