import 'package:admin_dokter_panggil/src/models/mr_kunjungan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrKunjunganPasienRepo {
  Future<MrKunjunganPasienModel> simpanKunjungan(
      MrKunjunganPasienRequestModel mrKunjunganPasienRequestModel) async {
    final response = await dio.post('/v2/mr/layanan-kunjungan',
        mrKunjunganPasienRequestModelToJson(mrKunjunganPasienRequestModel));
    return mrKunjunganPasienModelFromJson(response);
  }

  Future<MrKunjunganPasienModel> simpanKunjunganPaket(
      MrKunjunganPasienPaketRequestModel
          mrKunjunganPasienPaketRequestModel) async {
    final response = await dio.post(
        '/v2/mr/daftar-paket',
        mrKunjunganPasienPaketRequestModelToJson(
            mrKunjunganPasienPaketRequestModel));
    return mrKunjunganPasienModelFromJson(response);
  }
}
