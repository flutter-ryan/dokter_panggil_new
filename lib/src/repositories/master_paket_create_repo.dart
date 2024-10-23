import 'package:dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterPaketCreateRepo {
  Future<ResponseMasterPaketCreateModel> getMasterPaket(
      MasterPaketCreateModel masterPaketCreateModel) async {
    final response = await dio.post(
      '/v1/master/paket/filter',
      masterPaketCreateModelToJson(masterPaketCreateModel),
    );
    return responseMasterPaketCreateModelFromJson(response);
  }
}
