import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class PasienShowRepo {
  Future<PasienShowModel> pasienShow(int? id) async {
    final response = await dio.get('/v1/pasien/$id');
    return pasienShowModelFromJson(response);
  }
}
