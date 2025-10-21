import 'package:admin_dokter_panggil/src/models/download_kwitansi_model.dart';
import 'package:admin_dokter_panggil/src/repositories/dio_helper.dart';

class DownloadKwitansiRepo {
  Future<DownloadKwitansiModel> downloadKwitansi(int? idKunjungan) async {
    final response =
        await dio.get('/v1/layanan-kunjungan/download/kwitansi/$idKunjungan');
    return downloadKwitansiModelFromJson(response);
  }
}
