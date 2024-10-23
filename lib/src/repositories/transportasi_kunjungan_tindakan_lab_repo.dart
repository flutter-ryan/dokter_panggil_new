import 'package:dokter_panggil/src/models/transportasi_kunjungan_tindakan_lab_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TransportasiKunjunganTindakanLabRepo {
  Future<ResponseTransportasiKunjunganTindakanLabModel>
      saveTransportKunjunganTindakanLab(
          TransportasiKunjunganTindakanLabModel
              transportasiKunjunganTindakanLabModel,
          int? id) async {
    final response = await dio.put(
        '/v1/kunjungan/kunjungan-lab/transportasi/$id',
        transportasiKunjunganTindakanLabModelToJson(
            transportasiKunjunganTindakanLabModel));
    return responseTransportasiKunjunganTindakanLabModelFromJson(response);
  }
}
