import 'package:admin_dokter_panggil/src/models/pasien_filter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class PasienFilterRepo {
  Future<ResponsePasienFilterModel> filterPasien(
      PasienFilterModel pasienFilterModel) async {
    final response = await dio.post(
        '/v1/pasien/filter', pasienFilterModelToJson(pasienFilterModel));
    return responsePasienFilterModelFromJson(response);
  }
}
