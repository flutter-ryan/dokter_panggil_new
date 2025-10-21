import 'package:admin_dokter_panggil/src/models/transaksi_resep_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class TransaksiResepRepo {
  Future<ResponseTransaksiResepModel> saveTransaksiResep(
      int idKunjungan, TransaksiResepModel transaksiResepModel) async {
    final response = await dio.post('/v1/kunjungan/tagihan-resep/$idKunjungan',
        transaksiResepModelToJson(transaksiResepModel));
    return responseTransaksiResepModelFromJson(response);
  }
}
