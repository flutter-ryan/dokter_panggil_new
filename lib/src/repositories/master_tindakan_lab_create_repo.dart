import 'package:dokter_panggil/src/models/master_tindakan_lab_create_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterTindakanLabCreateRepo {
  Future<MasterTindakanLabCreateModel> getTindakanLab() async {
    final response = await dio.get('/v1/master/tindakan-lab/create');
    return masterTindakanLabCreateModelFromJson(response);
  }

  Future<MasterTindakanLabCreateModel> getJenisTindakanLab() async {
    final response = await dio.get('/v1/master/tindakan-lab/create-jenis');
    return masterTindakanLabCreateModelFromJson(response);
  }
}
