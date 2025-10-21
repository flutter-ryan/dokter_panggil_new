import 'package:admin_dokter_panggil/src/models/master_tindakan_rad_cari_modal.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class MasterTindakanRadCariRepo {
  Future<ResponseMasterTindakanRadCariModel> cariTindakanRad(
      MasterTindakanRadCariModel masterTindakanRadCariModel) async {
    final response = await dio.post('/v1/master/tindakan-rad/search',
        masterTindakanRadCariModelToJson(masterTindakanRadCariModel));
    return responseMasterTindakanRadCariModelFromJson(response);
  }
}
