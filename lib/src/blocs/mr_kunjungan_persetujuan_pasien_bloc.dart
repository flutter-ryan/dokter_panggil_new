import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_persetujuan_pasien_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_persetujuan_pasien_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganPersetujuanPasienBloc {
  final _repo = MrKunjunganPersetujuanPasienRepo();
  StreamController<ApiResponse<MrKunjunganPersetujuanPasienModel>>?
      _streamPersetujuan;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganPersetujuanPasienModel>>
      get persetujuanSink => _streamPersetujuan!.sink;
  Stream<ApiResponse<MrKunjunganPersetujuanPasienModel>>
      get persetujuanStream => _streamPersetujuan!.stream;

  Future<void> getPersetujuan() async {
    _streamPersetujuan = StreamController();
    final idKunjungan = _idKunjungan.value;
    persetujuanSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPersetujuan(idKunjungan);
      if (_streamPersetujuan!.isClosed) return;
      persetujuanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPersetujuan!.isClosed) return;
      persetujuanSink.add(ApiResponse.error(e.toString()));
    }
  }

  void disposet() {
    _streamPersetujuan?.close();
    _idKunjungan.close();
  }
}
