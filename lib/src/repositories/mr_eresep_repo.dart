import 'package:admin_dokter_panggil/src/models/mr_eresep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrEresepRepo {
  Future<MrEresepModel> getEresepInjeksi(
      MrEresepRequestModel mrEresepRequestModel) async {
    final response = await dio.post('/v2/mr/resep/injeksi',
        mrEresepRequestModelToJson(mrEresepRequestModel));
    return mrEresepModelFromJson(response);
  }

  Future<MrEresepModel> getEresepOral(
      MrEresepRequestModel mrEresepRequestModel) async {
    final response = await dio.post(
        '/v2/mr/resep/oral', mrEresepRequestModelToJson(mrEresepRequestModel));
    return mrEresepModelFromJson(response);
  }
}
