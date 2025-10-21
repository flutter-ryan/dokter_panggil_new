import 'package:admin_dokter_panggil/src/models/transportasi_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TransportasiResepRepo {
  Future<ResponseTransportasiResepModel> saveTransportResep(
      TransportasiResepModel transportasiResepModel) async {
    final response = await dio.post('/v2/mr/resep-oral/transportasi',
        transportasiResepModelToJson(transportasiResepModel));
    return responseTransportasiResepModelFromJson(response);
  }
}
