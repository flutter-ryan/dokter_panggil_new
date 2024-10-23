import 'package:dokter_panggil/src/models/kunjunga_pasien_all_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class RiwayatKunjunganAllRepo {
  Future<KunjunganPasienAllModel> getRiwayatKunjunganAll(int page) async {
    final response = await dio.get('/v1/kunjungan/riwayat/all?page=$page');
    return kunjunganPasienAllModelFromJson(response);
  }
}
