import 'dart:async';

import 'package:dokter_panggil/src/models/tagihan_resep_racikan_save_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/tagihan_resep_racikan_save_repo.dart';
import 'package:rxdart/subjects.dart';

class TagihanResepRacikanSaveBloc {
  final _repo = TagihanResepRacikanSaveRepo();
  StreamController<ApiResponse<TagihanResepRacikanSaveModel>>?
      _streamTagihanRacikan;
  final BehaviorSubject<int> _idResepRacikan = BehaviorSubject();
  final BehaviorSubject<List<BarangRacikanRequest>> _barangMitra =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<BarangRacikanRequest>> _barangMentari =
      BehaviorSubject.seeded([]);

  StreamSink<int> get idResepRacikan => _idResepRacikan.sink;
  StreamSink<List<BarangRacikanRequest>> get barangMitraSink =>
      _barangMitra.sink;
  StreamSink<List<BarangRacikanRequest>> get barangMentariSink =>
      _barangMentari.sink;
  StreamSink<ApiResponse<TagihanResepRacikanSaveModel>>
      get tagihanRacikanSink => _streamTagihanRacikan!.sink;
  Stream<ApiResponse<TagihanResepRacikanSaveModel>> get tagihanRacikanStream =>
      _streamTagihanRacikan!.stream;
  Future<void> saveTagihanRacikan() async {
    _streamTagihanRacikan = StreamController();
    final idResepRacikan = _idResepRacikan.value;
    final barangMitra = _barangMitra.value;
    final barangMentari = _barangMentari.value;
    tagihanRacikanSink.add(ApiResponse.loading('Memuat...'));
    TagihanResepRacikanRequestModel tagihanResepRacikanRequestModel =
        TagihanResepRacikanRequestModel(
            barangMitra: barangMitra, barangMentari: barangMentari);

    try {
      final res = await _repo.saveTagihanRacikan(
          tagihanResepRacikanRequestModel, idResepRacikan);
      if (_streamTagihanRacikan!.isClosed) return;
      tagihanRacikanSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTagihanRacikan!.isClosed) return;
      tagihanRacikanSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTagihanRacikan?.close();
    _barangMitra.close();
    _barangMentari.close();
  }
}
