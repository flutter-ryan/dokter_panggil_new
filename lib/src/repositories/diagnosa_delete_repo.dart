import 'package:dokter_panggil/src/models/diagnosa_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DiagnosaDeleteRepo {
  Future<ResponseDiagnosaModel> deleteDiagnosa(int? id) async {
    final response = await dio.delete('/v1/master/diagnosa/$id');
    return responseDiagnosaModelFromJson(response);
  }
}
