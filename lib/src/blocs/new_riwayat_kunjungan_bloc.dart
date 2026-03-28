import 'dart:async';

import 'package:admin_dokter_panggil/src/models/new_riwayat_kunjungan_model.dart';
import 'package:admin_dokter_panggil/src/repositories/new_riwayat_kunjungan_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class NewRiwayatKunjunganBloc {
  final _repo = NewRiwayatKunjunganRepo();
  StreamController<ApiResponse<NewRiwayatKunjunganModel>>?
      _streamRiwayatKunjungan;
  String? _nextPage;
  NewRiwayatKunjunganModel? dataRiwayat;
  final BehaviorSubject<String> _filter = BehaviorSubject.seeded('');
  StreamSink<String> get filterSink => _filter.sink;
  StreamSink<ApiResponse<NewRiwayatKunjunganModel>> get riwayatKunjunganSink =>
      _streamRiwayatKunjungan!.sink;
  Stream<ApiResponse<NewRiwayatKunjunganModel>> get riwayatKunjunganStream =>
      _streamRiwayatKunjungan!.stream;

  Future<void> getRiwayatKunjungan() async {
    _streamRiwayatKunjungan = StreamController();
    final filter = _filter.value;
    riwayatKunjunganSink.add(ApiResponse.loading('Memuat...'));
    NewRiwayatKunjunganRequestModel newRiwayatKunjunganRequestModel =
        NewRiwayatKunjunganRequestModel(filter: filter);
    try {
      final res =
          await _repo.getRiwayatKunjungan(newRiwayatKunjunganRequestModel);
      if (_streamRiwayatKunjungan!.isClosed) return;
      _nextPage = res.nextPageUrl;
      dataRiwayat = res;
      riwayatKunjunganSink.add(ApiResponse.completed(dataRiwayat));
    } catch (e) {
      if (_streamRiwayatKunjungan!.isClosed) return;
      riwayatKunjunganSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> nextPage() async {
    final filter = _filter.value;
    NewRiwayatKunjunganRequestModel newRiwayatKunjunganRequestModel =
        NewRiwayatKunjunganRequestModel(filter: filter);
    try {
      final res = await _repo.nextPageRiwayat(
          _nextPage!, newRiwayatKunjunganRequestModel);
      if (_streamRiwayatKunjungan!.isClosed) return;
      _nextPage = res.nextPageUrl;
      dataRiwayat!.nextPageUrl = _nextPage;
      dataRiwayat!.data!.addAll(res.data!);
      riwayatKunjunganSink.add(ApiResponse.completed(dataRiwayat));
    } catch (e) {
      if (_streamRiwayatKunjungan!.isClosed) return;
      riwayatKunjunganSink.add(ApiResponse.completed(dataRiwayat));
    }
  }

  void dispose() {
    _streamRiwayatKunjungan?.close();
    _filter.close();
  }
}
