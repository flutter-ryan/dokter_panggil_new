import 'package:dokter_panggil/src/models/transportasi_resep_racikan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TransportasiResepRacikanRepo {
  Future<ResponseTransportasiResepRacikanModel> saveTransportResep(
      TransportasiResepRacikanModel transportasiResepModel) async {
    final response = await dio.post('/v1/kunjungan/transportasi/resep-racikan',
        transportasiResepRacikanModelToJson(transportasiResepModel));
    return responseTransportasiResepRacikanModelFromJson(response);
  }
}
