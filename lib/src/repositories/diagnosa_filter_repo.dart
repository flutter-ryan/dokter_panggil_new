import 'package:admin_dokter_panggil/src/models/diagnosa_filter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class DiagnosaFilterRepo {
  Future<ResponseDiagnosaFilterModel> filterDiagnosa(
      DiagnosaFilterModel diagnosaFilterModel) async {
    final response = await dio.post('/v1/master/diagnosa/filter',
        diagnosaFilterModelToJson(diagnosaFilterModel));
    return responseDiagnosaFilterModelFromJson(response);
  }
}
