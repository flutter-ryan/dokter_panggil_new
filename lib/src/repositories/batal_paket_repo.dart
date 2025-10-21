import 'package:admin_dokter_panggil/src/models/response_batal_paket_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class BatalPaketRepo {
  Future<ResponseBatalPaketModel> batalPaket(int id) async {
    final response = await dio.get('/v1/kunjungan/paket/batal/$id');
    return responseBatalPaketModelFromJson(response);
  }
}
