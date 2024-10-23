import 'package:dokter_panggil/src/models/master_barang_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterBarangLabRepo {
  Future<MasterBarangLabModel> getBarangLab() async {
    final response = await dio.get('/v1/master/barang-lab');
    return masterBarangLabModelFromJson(response);
  }

  Future<MasterBarangLabModel> saveBarangLab(
      MasterBarangLabSaveModel masterBarangLabSaveModel) async {
    final response = await dio.post('/v1/master/barang-lab',
        masterBarangLabSaveModelToJson(masterBarangLabSaveModel));
    return masterBarangLabModelFromJson(response);
  }

  Future<ResponseMasterBarangLabModel> updateBarangLab(
      MasterBarangLabRequestModel masterBarangLabRequestModel,
      int idBarangLab) async {
    final response = await dio.put('/v1/master/barang-lab/$idBarangLab',
        masterBarangLabRequestModelToJson(masterBarangLabRequestModel));
    return responseMasterBarangLabModelFromJson(response);
  }

  Future<ResponseMasterBarangLabModel> deleteBarangLab(int idBarangLab) async {
    final response = await dio.delete('/v1/master/barang-lab/$idBarangLab}');
    return responseMasterBarangLabModelFromJson(response);
  }
}
