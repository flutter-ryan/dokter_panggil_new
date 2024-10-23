import 'package:dokter_panggil/src/models/transaksi_bhp_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TransaksiBhpRepo {
  Future<ResponseTransaksiBhpModel> saveTransaksiBhp(
      int idKunjungan, TransaksiBhpModel transaksiBhpModel) async {
    final response = await dio.post('/v1/kunjungan/tagihan-bhp/$idKunjungan',
        transaksiBhpModelToJson(transaksiBhpModel));
    return responseTransaksiBhpModelFromJson(response);
  }
}
