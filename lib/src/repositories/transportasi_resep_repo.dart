import 'package:dokter_panggil/src/models/transportasi_resep_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TransportasiResepRepo {
  Future<ResponseTransportasiResepModel> saveTransportResep(
      TransportasiResepModel transportasiResepModel) async {
    final response = await dio.post('/v1/kunjungan/transportasi/resep',
        transportasiResepModelToJson(transportasiResepModel));
    return responseTransportasiResepModelFromJson(response);
  }
}
