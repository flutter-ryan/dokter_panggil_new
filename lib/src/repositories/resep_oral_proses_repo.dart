import 'package:admin_dokter_panggil/src/models/resep_oral_proses_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class ResepOralProsesRepo {
  Future<ResepOralProsesModel> prosesResepOral(
      ResepOralProsesRequestModel resepOralProsesRequestModel,
      int idResepOral) async {
    final response = await dio.put('/v2/mr/resep-oral/$idResepOral',
        resepOralProsesRequestModelToJson(resepOralProsesRequestModel));
    return resepOralProsesModelFromJson(response);
  }
}
