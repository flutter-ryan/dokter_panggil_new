import 'package:dokter_panggil/src/models/pasien_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class PasienDeleteRepo {
  Future<ResponsePasienModel> deletePasien(int? id) async {
    final response = await dio.delete('/v1/pasien/$id');
    return responsePasienModelFromJson(response);
  }
}
