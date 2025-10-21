import 'package:admin_dokter_panggil/src/models/master_mitra_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterMitraLabRepo {
  Future<MasterMitraLabModel> getMitraLab() async {
    final response = await dio.get('/v1/master/mitra/tindakan-lab/create');
    return masterMitraLabModelFromJson(response);
  }
}
