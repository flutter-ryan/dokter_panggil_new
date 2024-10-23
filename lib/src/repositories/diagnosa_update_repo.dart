import 'package:dokter_panggil/src/models/diagnosa_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class DiagnosaUpdateRepo {
  Future<ResponseDiagnosaModel> updateDiagnosa(
      int? id, DiagnosaModel diagnosaModel) async {
    final response = await dio.put(
        '/v1/master/diagnosa/$id', diagnosaModelToJson(diagnosaModel));
    return responseDiagnosaModelFromJson(response);
  }
}
