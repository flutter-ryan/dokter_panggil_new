import 'package:admin_dokter_panggil/src/models/kunjunga_pasien_all_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class KunjunganPasienAllRepo {
  Future<KunjunganPasienAllModel> getKunjungan(int page) async {
    final response = await dio.get('/v1/kunjungan/create/all?page=$page');
    return kunjunganPasienAllModelFromJson(response);
  }
}
