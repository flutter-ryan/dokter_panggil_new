import 'package:admin_dokter_panggil/src/models/pasien_page_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class PasienPageRepo {
  Future<PasienPageModel> getPagePasien(int page) async {
    final response = await dio.get('/v1/pasien/create/all?page=$page');
    return pasienPageModelFromJson(response);
  }
}
