import 'package:dokter_panggil/src/models/transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TransportasiTindakanRepo {
  Future<ResponseTransportasiTindakanModel> saveTransportasiTindakan(
      TransportasiTindakanModel transportasiTindakanModel, int id) async {
    final response = await dio.post('/v1/kunjungan/transportasi/tindakan/$id',
        transportasiTindakanModelToJson(transportasiTindakanModel));
    return responseTransportasiTindakanModelFromJson(response);
  }

  Future<ResponseTransportasiTindakanModel> deleteTransportasiTindakan(
      int idTransportTindakan) async {
    final response = await dio
        .delete('/v1/kunjungan/transportasi/tindakan/$idTransportTindakan');
    return responseTransportasiTindakanModelFromJson(response);
  }
}
