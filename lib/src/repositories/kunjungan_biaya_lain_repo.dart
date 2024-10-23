import 'package:dokter_panggil/src/models/kunjungan_biaya_lain_model.dart';
import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganBiayaLainRepo {
  Future<PasienKunjunganDetailModel> saveBiayaLain(
      KunjunganBiayaLainModel kunjunganBiayaLainModel) async {
    final response = await dio.post('/v1/layanan-kunjungan/biaya-lain',
        kunjunganBiayaLainModelToJson(kunjunganBiayaLainModel));
    return pasienKunjunganDetailModelFromJson(response);
  }

  Future<PasienKunjunganDetailModel> deleteBiayaLain(int? idBiaya) async {
    final response =
        await dio.delete('/v1/layanan-kunjungan/biaya-lain/$idBiaya');
    return pasienKunjunganDetailModelFromJson(response);
  }
}
