import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tagihan_resep_oral_save_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tagihan_resep_oral_save_repo.dart';
import 'package:rxdart/subjects.dart';

class TagihanResepOralSaveBloc {
  final _repo = TagihanResepOralSaveRepo();
  StreamController<ApiResponse<TagihanResepOralSaveModel>>?
      _streamTagihanResepOral;
  final BehaviorSubject<int> _idResepOral = BehaviorSubject();
  final BehaviorSubject<List<BarangRequest>> _barangMitra =
      BehaviorSubject.seeded([]);
  final BehaviorSubject<List<BarangRequest>> _barangMentari =
      BehaviorSubject.seeded([]);
  StreamSink<int> get idResepOralSink => _idResepOral.sink;
  StreamSink<List<BarangRequest>> get barangMitraSink => _barangMitra.sink;
  StreamSink<List<BarangRequest>> get barangMentariSink => _barangMentari.sink;
  StreamSink<ApiResponse<TagihanResepOralSaveModel>> get tagihanResepOralSink =>
      _streamTagihanResepOral!.sink;
  Stream<ApiResponse<TagihanResepOralSaveModel>> get tagihanResepOralStream =>
      _streamTagihanResepOral!.stream;

  Future<void> saveTagihanResepOral() async {
    _streamTagihanResepOral = StreamController();
    final idResepOral = _idResepOral.value;
    final barangMitra = _barangMitra.value;
    final barangMentari = _barangMentari.value;
    tagihanResepOralSink.add(ApiResponse.loading("Memuat..."));
    TagihanResepOralRequestModel tagihanResepOralRequestModel =
        TagihanResepOralRequestModel(
            barangMitra: barangMitra, barangMentari: barangMentari);

    try {
      final res = await _repo.saveTagihanResepOral(
          tagihanResepOralRequestModel, idResepOral);
      if (_streamTagihanResepOral!.isClosed) return;
      tagihanResepOralSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTagihanResepOral!.isClosed) return;
      tagihanResepOralSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTagihanResepOral?.close();
    _idResepOral.close();
    _barangMentari.close();
    _barangMitra.close();
  }
}
