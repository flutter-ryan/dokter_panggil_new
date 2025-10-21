import 'package:admin_dokter_panggil/src/models/mr_petugas_konsul_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MrPetugasKonsulSaveRepo {
  Future<MrPetugasKonsulSaveModel> simpanPetugasKonsul(
      MrPetugasKonsulRequestModel mrPetugasKonsulRequestModel) async {
    final response = await dio.post('/v2/mr/dokter-konsul',
        mrPetugasKonsulRequestModelToJson(mrPetugasKonsulRequestModel));
    return mrPetugasKonsulSaveModelFromJson(response);
  }

  Future<MrPetugasKonsulSaveModel> deletePetugasKonsul(int idKonfirmasi) async {
    final response = await dio.delete('/v2/mr/dokter-konsul/$idKonfirmasi');
    return mrPetugasKonsulSaveModelFromJson(response);
  }
}
