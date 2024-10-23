import 'package:dokter_panggil/src/models/biaya_transportasi_tindakan_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class BiayaTransportasiTindakanRepo {
  Future<BiayaTransportasiTindakanModel> getTransportasiTindakan(int id) async {
    final response =
        await dio.get('/v1/master/pengaturan-biaya/transportasi-tindakan/$id');
    return biayaTransportasiTindakanModelFromJson(response);
  }

  Future<BiayaTransportasiTindakanModel> saveTransportasiTindakan(
      BiayaTransportasiTindakanSaveModel
          biayaTransportasiTindakanSaveModel) async {
    final response = await dio.post(
        '/v1/master/pengaturan-biaya/transportasi-tindakan',
        biayaTransportasiTindakanSaveModelToJson(
            biayaTransportasiTindakanSaveModel));
    return biayaTransportasiTindakanModelFromJson(response);
  }

  Future<BiayaTransportasiTindakanModel> updateTransportasiTindakan(
      BiayaTransportasiTindakanSaveModel biayaTransportasiTindakanSaveModel,
      int id) async {
    final response = await dio.put(
        '/v1/master/pengaturan-biaya/transportasi-tindakan/$id',
        biayaTransportasiTindakanSaveModelToJson(
            biayaTransportasiTindakanSaveModel));
    return biayaTransportasiTindakanModelFromJson(response);
  }

  Future<BiayaTransportasiTindakanModel> deleteTransportasiTindakan(
      int id) async {
    final response = await dio
        .delete('/v1/master/pengaturan-biaya/transportasi-tindakan/$id');
    return biayaTransportasiTindakanModelFromJson(response);
  }
}
