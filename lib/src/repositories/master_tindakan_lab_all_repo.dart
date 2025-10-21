import 'package:admin_dokter_panggil/src/models/master_tindakan_lab_all_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterTindakanLabAllRepo {
  Future<MasterTindakanLabAllModel> getMasterTindakanLab() async {
    final response = await dio.get('/v1/master/tindakan-lab');
    return masterTindakanLabAllModelFromJson(response);
  }

  Future<MasterTindakanLabAllModel> getTindakanLabNonkonsul() async {
    final response = await dio.get('/v1/master/tindakan-lab/non-konsul/create');
    return masterTindakanLabAllModelFromJson(response);
  }
}
