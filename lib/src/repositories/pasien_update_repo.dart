import 'package:dokter_panggil/src/models/pasien_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class PasienUpdateRepo {
  Future<ResponsePasienModel> updatePasien(
      int? id, PasienModel pasienModel) async {
    final response =
        await dio.put('/v1/pasien/$id', pasienModelToJson(pasienModel));
    return responsePasienModelFromJson(response);
  }
}
