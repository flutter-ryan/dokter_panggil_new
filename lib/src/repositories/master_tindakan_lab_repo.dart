import 'package:dokter_panggil/src/models/master_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterTindakanLabRepo {
  Future<MasterTindakanLabModel> getTindakanLab(int idMitra) async {
    final response = await dio.get('/v1/master/tindakan-lab/$idMitra');
    return masterTindakanLabModelFromJson(response);
  }
}
