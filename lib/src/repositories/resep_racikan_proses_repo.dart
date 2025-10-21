import 'package:admin_dokter_panggil/src/models/resep_racikan_proses_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class ResepRacikanProsesRepo {
  Future<ResepRacikanProsesModel> prosesResepRacikan(
      ResepRacikanProsesRequestModel resepRacikanProsesRequestModel,
      int idResepRacikan) async {
    final response = await dio.put('/v2/mr/resep-racikan/$idResepRacikan',
        resepRacikanProsesRequestModelToJson(resepRacikanProsesRequestModel));
    return resepRacikanProsesModelFromJson(response);
  }
}
