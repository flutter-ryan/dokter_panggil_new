import 'package:dokter_panggil/src/models/transaksi_resep_model.dart';
import 'package:dokter_panggil/src/repositories/dio_helper.dart';

class TransaksiResepRacikanRepo {
  Future<ResponseTransaksiResepModel> saveTransaksiResepRacikan(
      int idKunjungan, TransaksiResepModel transaksiResepModel) async {
    final response = await dio.post(
        '/v1/kunjungan/tagihan-resep-racikan/$idKunjungan',
        transaksiResepModelToJson(transaksiResepModel));
    return responseTransaksiResepModelFromJson(response);
  }
}
