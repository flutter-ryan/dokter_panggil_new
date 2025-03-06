import 'package:dokter_panggil/src/models/transportasi_resep_racikan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TransportasiResepRacikanRepo {
  Future<ResponseTransportasiResepRacikanModel> saveTransportResep(
      TransportasiResepRacikanModel transportasiResepModel) async {
    final response = await dio.post('/v2/mr/resep-racikan/transportasi',
        transportasiResepRacikanModelToJson(transportasiResepModel));
    return responseTransportasiResepRacikanModelFromJson(response);
  }
}
