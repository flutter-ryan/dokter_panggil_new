import 'dart:async';

import 'package:dokter_panggil/src/models/token_fcm_save_model.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/repositories/token_fcm_save_repo.dart';
import 'package:rxdart/subjects.dart';

class TokenFcmSaveBloc {
  final _repo = TokenFcmSaveRepo();
  StreamController<ApiResponse<ResponseTokenFcmSaveModel>>? _streamTokenFcmSave;
  final BehaviorSubject<String> _token = BehaviorSubject();
  StreamSink<String> get tokenSink => _token.sink;
  StreamSink<ApiResponse<ResponseTokenFcmSaveModel>> get tokenFcmSaveSink =>
      _streamTokenFcmSave!.sink;
  Stream<ApiResponse<ResponseTokenFcmSaveModel>> get tokenFcmStream =>
      _streamTokenFcmSave!.stream;

  Future<void> saveTokenFcm() async {
    _streamTokenFcmSave = StreamController();
    final token = _token.value;
    tokenFcmSaveSink.add(ApiResponse.loading('Memuat...'));
    TokenFcmSaveModel tokenFcmSaveModel = TokenFcmSaveModel(token: token);
    try {
      final res = await _repo.saveTokenFcm(tokenFcmSaveModel);
      if (_streamTokenFcmSave!.isClosed) return;
      tokenFcmSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTokenFcmSave!.isClosed) return;
      tokenFcmSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamTokenFcmSave?.close();
    _token.close();
  }
}
