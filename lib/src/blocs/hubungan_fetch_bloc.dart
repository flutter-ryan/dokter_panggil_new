import 'dart:async';

import 'package:dokter_panggil/src/models/hubungan_fetch_model.dart';
import 'package:dokter_panggil/src/repositories/hubungan_fetch_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';

class HubunganFetchBloc {
  final HubunganFetchRepo _repo = HubunganFetchRepo();
  StreamController<ApiResponse<HubunganFetchModel>>? _streamHubunganFetch;
  StreamSink<ApiResponse<HubunganFetchModel>> get hubunganFetchSink =>
      _streamHubunganFetch!.sink;
  Stream<ApiResponse<HubunganFetchModel>> get hubunganFetchStream =>
      _streamHubunganFetch!.stream;

  Future<void> fetchHubungan() async {
    _streamHubunganFetch = StreamController();
    hubunganFetchSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.fetchHubungan();
      if (_streamHubunganFetch!.isClosed) return;
      hubunganFetchSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamHubunganFetch!.isClosed) return;
      hubunganFetchSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamHubunganFetch?.close();
  }
}
