import 'package:admin_dokter_panggil/src/models/diagnosa_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class DiagnosaSaveRepo {
  Future<ResponseDiagnosaModel> saveDiagnosa(
      DiagnosaModel diagnosaModel) async {
    final response = await dio.post(
        '/v1/master/diagnosa', diagnosaModelToJson(diagnosaModel));
    return responseDiagnosaModelFromJson(response);
  }
}
