import 'package:dokter_panggil/src/models/master_transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class MasterTransportasiTindakanRepo {
  Future<MasterTransportasiTindakanModel> getTransportasiTindakan() async {
    final response = await dio.get('/v1/master/transportasi-tindakan/create');
    return masterTransportasiTindakanModelFromJson(response);
  }
}
