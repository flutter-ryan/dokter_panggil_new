import 'package:admin_dokter_panggil/src/models/pencarian_master_tindakan_group_model.dart';
import 'package:admin_dokter_panggil/src/models/tindakan_filter_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TindakanFilterRepo {
  Future<ResponseTindakanFilterModel> filterTindakan(
      TindakanFilterModel tindakanFilterModel) async {
    final response = await dio.post('/v1/master/tindakan/filter',
        tindakanFilterModelToJson(tindakanFilterModel));
    return responseTindakanFilterModelFromJson(response);
  }

  Future<ResponseTindakanFilterModel> filterTindakanGroup(
      PencarianMasterTindakanGroupModel
          pencarianMasterTindakanGroupModel) async {
    final response = await dio.post(
        '/v1/master/tindakan/group',
        pencarianMasterTindakanGroupModelToJson(
            pencarianMasterTindakanGroupModel));
    return responseTindakanFilterModelFromJson(response);
  }
}
