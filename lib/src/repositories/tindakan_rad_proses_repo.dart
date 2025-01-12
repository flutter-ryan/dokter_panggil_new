import 'package:dokter_panggil/src/models/tindakan_rad_proses_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TindakanRadProsesRepo {
  Future<TindakanRadProsesModel> prosesTindakanRad(
      TindakanRadProsesRequestModel tindakanRadProsesRequestModel,
      int idPengantar) async {
    final response = await dio.put('/v2/mr/radiologi/$idPengantar',
        tindakanRadProsesRequestModelToJson(tindakanRadProsesRequestModel));
    return tindakanRadProsesModelFromJson(response);
  }
}
