import 'package:dokter_panggil/src/models/batal_final_petugas_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class BatalFinalPetugasRepo {
  Future<ResponseBatalFinalPetugasModel> batalFinalPetugas(
      BatalFinalPetugasModel batalFinalPetugasModel, int id) async {
    final response = await dio.put('/v1/layanan-kunjungan/batal-final/$id',
        batalFinalPetugasModelToJson(batalFinalPetugasModel));
    return responseBatalFinalPetugasModelFromJson(response);
  }
}
