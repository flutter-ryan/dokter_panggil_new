import 'package:admin_dokter_panggil/src/models/transaksi_tindakan_lab_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TransaksiTindakanLabRepo {
  Future<ResponseTransaksiTindakanLabModel> saveTransaksiTindakanLab(
      int idKunjugan,
      TransaksiTindakanLabModel transaksiTindakanLabModel) async {
    final response = await dio.post('/v1/kunjungan/tagihan-lab/$idKunjugan',
        transaksiTindakanLabModelToJson(transaksiTindakanLabModel));
    return responseTransaksiTindakanLabModelFromJson(response);
  }
}
