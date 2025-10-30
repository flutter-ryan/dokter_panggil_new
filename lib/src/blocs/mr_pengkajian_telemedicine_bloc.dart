import 'dart:async';
import 'package:admin_dokter_panggil/src/models/mr_pengkajian_telemedicine_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_pengkajian_telemedicine_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MrPengkajianTelemedicineBloc {
  final _repo = MrPengkajianTelemedicineRepo();
  StreamController<ApiResponse<MrKunjunganTelemedicineModel>>?
      _streamPengkajianTelemedicine;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<MrKunjunganTelemedicineModel>>
      get pengkajianTelemedicineSink => _streamPengkajianTelemedicine!.sink;
  Stream<ApiResponse<MrKunjunganTelemedicineModel>>
      get pengkajianTelemedicineStream => _streamPengkajianTelemedicine!.stream;

  Future<void> getPengkajianTelemedicine() async {
    _streamPengkajianTelemedicine = StreamController();
    final idKunjungan = _idKunjungan.value;
    pengkajianTelemedicineSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPengkajianTelemedicine(idKunjungan);
      if (_streamPengkajianTelemedicine!.isClosed) return;
      pengkajianTelemedicineSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamPengkajianTelemedicine!.isClosed) return;
      pengkajianTelemedicineSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamPengkajianTelemedicine?.close();
    _idKunjungan.close();
  }
}
