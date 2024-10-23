import 'package:dokter_panggil/src/models/mitra_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MitraUpdateRepo {
  Future<ResponseMitraModel> updateMitra(int? id, MitraModel mitraModel) async {
    final response =
        await dio.put('/v1/master/mitra/$id', mitraModelToJson(mitraModel));
    return responseMitraModelFromJson(response);
  }
}
