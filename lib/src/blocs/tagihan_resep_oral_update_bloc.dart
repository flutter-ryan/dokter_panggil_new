import 'dart:async';

import 'package:admin_dokter_panggil/src/models/tagihan_resep_oral_update_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/tagihan_resep_oral_update_repo.dart';
import 'package:rxdart/subjects.dart';

class TagihanResepOralUpdateBloc {
  final _repo = TagihanResepOralUpdateRepo();
  StreamController<ApiResponse<TagihanResepOralUpdateModel>>?
      _streamTagihanResepOral;
  final BehaviorSubject<int> _idBarangResepOral = BehaviorSubject();
  final BehaviorSubject<int> _jumlah = BehaviorSubject();
  StreamSink<int> get idBarangResepOralSink => _idBarangResepOral.sink;
  StreamSink<int> get jumlahSink => _jumlah.sink;
  StreamSink<ApiResponse<TagihanResepOralUpdateModel>>
      get tagihanResepOralSink => _streamTagihanResepOral!.sink;
  Stream<ApiResponse<TagihanResepOralUpdateModel>> get tagihanResepOralStream =>
      _streamTagihanResepOral!.stream;

  Future<void> updateTagihanResepOral() async {
    _streamTagihanResepOral = StreamController();
    final idBarangResepOral = _idBarangResepOral.value;
    final jumlah = _jumlah.value;
    tagihanResepOralSink.add(ApiResponse.loading('Memuat...'));
    TagihanResepOralRequestUpdateModel tagihanResepOralRequestUpdateModel =
        TagihanResepOralRequestUpdateModel(jumlah: jumlah);
    try {
      final res = await _repo.updateTagihanResepOral(
          tagihanResepOralRequestUpdateModel, idBarangResepOral);
      if (_streamTagihanResepOral!.isClosed) return;
      tagihanResepOralSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTagihanResepOral!.isClosed) return;
      tagihanResepOralSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> deleteTagihanResepOral() async {
    _streamTagihanResepOral = StreamController();
    final idBarangResepOral = _idBarangResepOral.value;
    tagihanResepOralSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.deleteTagihanResepOral(idBarangResepOral);
      if (_streamTagihanResepOral!.isClosed) return;
      tagihanResepOralSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTagihanResepOral!.isClosed) return;
      tagihanResepOralSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTagihanResepOral?.close();
    _idBarangResepOral.close();
    _jumlah.close();
  }
}
