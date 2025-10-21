import 'package:admin_dokter_panggil/src/models/tindakan_lab_proses_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TindakanLabProsesRepo {
  Future<TindakanLabProsesModel> prosesTindakanLab(
      TindakanLabProsesRequestModel tindakanLabProsesRequestModel,
      int idPengantar) async {
    final response = await dio.put('/v2/mr/laboratorium/$idPengantar',
        tindakanLabProsesRequestModelToJson(tindakanLabProsesRequestModel));
    return tindakanLabProsesModelFromJson(response);
  }
}
