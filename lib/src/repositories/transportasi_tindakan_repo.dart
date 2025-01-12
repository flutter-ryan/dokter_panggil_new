import 'package:dokter_panggil/src/models/transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TransportasiTindakanRepo {
  Future<ResponseTransportasiTindakanModel> saveTransportasiTindakan(
      TransportasiTindakanModel transportasiTindakanModel,
      int idKunjungan) async {
    final response = await dio.post('/v2/mr/tindakan/transportasi/$idKunjungan',
        transportasiTindakanModelToJson(transportasiTindakanModel));
    return responseTransportasiTindakanModelFromJson(response);
  }

  Future<ResponseTransportasiTindakanModel> deleteTransportasiTindakan(
      int idTransportTindakan) async {
    final response =
        await dio.delete('/v2/mr/tindakan/transportasi/$idTransportTindakan');
    return responseTransportasiTindakanModelFromJson(response);
  }
}
