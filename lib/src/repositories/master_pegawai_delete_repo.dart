import 'package:dokter_panggil/src/models/master_pegawai_save_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterPegawaiDeleteRepo {
  Future<ResponseMasterPegawaiSaveModel> deletePegawai(int? id) async {
    final response = await dio.delete('/v1/master/pegawai/$id');
    return responseMasterPegawaiSaveModelFromJson(response);
  }
}
