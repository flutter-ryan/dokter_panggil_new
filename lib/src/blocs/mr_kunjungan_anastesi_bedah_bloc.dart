import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_kunjungan_anastesi_bedah_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_kunjungan_anastesi_bedah_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrKunjunganAnastesiBedahBloc {
  final _repo = MrKunjunganBedahAnastesiRepo();
  StreamController<ApiResponse<MrKunjunganAnastesiBedahModel>>?
      _streamAnastesiBedah;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganAnastesiBedahModel>>
      get anastesiBedahSink => _streamAnastesiBedah!.sink;
  Stream<ApiResponse<MrKunjunganAnastesiBedahModel>> get anastesiBedahStream =>
      _streamAnastesiBedah!.stream;

  Future<void> getAnastesiBedah() async {
    _streamAnastesiBedah = StreamController();
    final idKunjungan = _idKunjungan.value;
    anastesiBedahSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getAnastesiBedah(idKunjungan);
      if (_streamAnastesiBedah!.isClosed) return;
      anastesiBedahSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamAnastesiBedah!.isClosed) return;
      anastesiBedahSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamAnastesiBedah?.close();
    _idKunjungan.close();
  }
}
