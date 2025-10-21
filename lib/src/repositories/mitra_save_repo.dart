import 'package:admin_dokter_panggil/src/models/mitra_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MitraSaveRepo {
  Future<ResponseMitraModel> saveMitra(MitraModel mitraModel) async {
    final response =
        await dio.post('/v1/master/mitra', mitraModelToJson(mitraModel));
    return responseMitraModelFromJson(response);
  }
}
