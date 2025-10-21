import 'dart:async';

import 'package:admin_dokter_panggil/src/models/pasien_page_model.dart';
import 'package:admin_dokter_panggil/src/repositories/pasien_page_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';

class PasienPageBloc {
  final _repo = PasienPageRepo();
  int page = 0;
  PasienPageModel? pasien;
  StreamController<ApiResponse<PasienPageModel>>? _streamPasienPage;
  StreamSink<ApiResponse<PasienPageModel>> get pasienPageSink =>
      _streamPasienPage!.sink;
  Stream<ApiResponse<PasienPageModel>> get pasienPageStream =>
      _streamPasienPage!.stream;

  Future<void> getPagePasien() async {
    _streamPasienPage = StreamController();
    page = 0;
    pasienPageSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getPagePasien(page + 1);
      pasien = res;
      page = res.currentPage!;
      if (_streamPasienPage!.isClosed) return;
      pasienPageSink.add(ApiResponse.completed(pasien));
    } catch (e) {
      if (_streamPasienPage!.isClosed) return;
      pasienPageSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> getNextPagePasien() async {
    try {
      final res = await _repo.getPagePasien(page + 1);
      if (_streamPasienPage!.isClosed) return;
      pasien!.data!.addAll(res.data!);
      pasien!.currentPage = res.currentPage;
      pasienPageSink.add(ApiResponse.completed(pasien));
    } catch (e) {
      if (_streamPasienPage!.isClosed) return;
      pasienPageSink.add(ApiResponse.completed(pasien));
    }
  }

  void dispose() {
    _streamPasienPage?.close();
  }
}
