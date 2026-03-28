import 'dart:async';

import 'package:admin_dokter_panggil/src/models/token_fcm_model.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/repositories/token_fcm_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenFcmBloc {
  final _repo = TokenFcmRepo();
  StreamController<ApiResponse<TokenFcmModel>>? _streamTokenFcm;
  final BehaviorSubject<String> _token = BehaviorSubject();
  StreamSink<String> get tokenSink => _token.sink;
  StreamSink<ApiResponse<TokenFcmModel>> get tokenFcmSink =>
      _streamTokenFcm!.sink;
  Stream<ApiResponse<TokenFcmModel>> get tokenFcmStream =>
      _streamTokenFcm!.stream;

  Future<void> updateTokenFcm() async {
    _streamTokenFcm = StreamController();
    final token = _token.value;
    tokenFcmSink.add(ApiResponse.loading('Memuat...'));
    TokenFcmRequestModel tokenFcmRequestModel =
        TokenFcmRequestModel(token: token);
    try {
      final res = await _repo.updateTokenFcm(tokenFcmRequestModel);
      if (_streamTokenFcm!.isClosed) return;
      // Simpan lokal token fcm
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('tokenFcm', '${res.data!.token}');

      tokenFcmSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamTokenFcm!.isClosed) return;
      tokenFcmSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamTokenFcm?.close();
    _token.close();
  }
}
