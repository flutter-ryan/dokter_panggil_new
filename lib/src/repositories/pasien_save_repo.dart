import 'package:dokter_panggil/src/models/pasien_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class PasienSaveRepo {
  Future<ResponsePasienModel> savePasien(PasienModel pasienModel) async {
    final response =
        await dio.post('/v1/pasien', pasienModelToJson(pasienModel));
    return responsePasienModelFromJson(response);
  }
}
