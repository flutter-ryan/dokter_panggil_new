import 'package:dokter_panggil/src/models/pasien_kunjungan_detail_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class PasienKunjunganDetailRepo {
  Future<PasienKunjunganDetailModel> detailKunjungan(int? id) async {
    final response = await dio.get('/v1/kunjungan/tagihan/$id');
    return pasienKunjunganDetailModelFromJson(response);
  }
}
