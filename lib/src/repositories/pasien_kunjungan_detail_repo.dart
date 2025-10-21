import 'package:admin_dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class PasienKunjunganDetailRepo {
  Future<PasienKunjunganDetailModel> detailKunjungan(int? idKunjungan) async {
    final response = await dio.get('/v2/mr/kunjungan/$idKunjungan');
    return pasienKunjunganDetailModelFromJson(response);
  }
}
