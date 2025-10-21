import 'dart:async';

import 'package:admin_dokter_panggil/src/models/pendaftaran_kunjungan_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/kunjungan_batal_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class KunjunganBatalBloc {
  final KunjunganBatalRepo _repo = KunjunganBatalRepo();
  StreamController<ApiResponse<ResponsePendaftaranKunjunganSaveModel>>?
      _streamKunjunganBatal;
  final BehaviorSubject<int> _id = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<ApiResponse<ResponsePendaftaranKunjunganSaveModel>>
      get kunjunganBatalSink => _streamKunjunganBatal!.sink;
  Stream<ApiResponse<ResponsePendaftaranKunjunganSaveModel>>
      get kunjunganBatalStream => _streamKunjunganBatal!.stream;

  Future<void> batalKunjungan() async {
    _streamKunjunganBatal = StreamController();
    final id = _id.value;
    kunjunganBatalSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.batalKunjungan(id);
      if (_streamKunjunganBatal!.isClosed) return;
      kunjunganBatalSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamKunjunganBatal!.isClosed) return;
      kunjunganBatalSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _id.close();
    _streamKunjunganBatal?.close();
  }
}
