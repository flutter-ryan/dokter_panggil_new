import 'dart:async';

import 'package:dokter_panggil/src/models/bhp_stock_model.dart';
import 'package:dokter_panggil/src/repositories/bhp_stock_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class BhpStockBloc {
  final BhpStockRepo _repo = BhpStockRepo();
  StreamController<ApiResponse<ResponseBhpStockModel>>? _streamBhpStock;
  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _action = BehaviorSubject.seeded('add');
  final BehaviorSubject<String> _jumlah = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get actionSink => _action.sink;
  StreamSink<String> get jumlahSink => _jumlah.sink;
  StreamSink<ApiResponse<ResponseBhpStockModel>> get bhpStockSink =>
      _streamBhpStock!.sink;
  Stream<ApiResponse<ResponseBhpStockModel>> get bhpStockStream =>
      _streamBhpStock!.stream;

  Future<void> tambahStockBhp() async {
    _streamBhpStock = StreamController();
    final id = _id.value;
    final action = _action.value;
    final jumlah = _jumlah.value;
    bhpStockSink.add(ApiResponse.loading('Memuat...'));
    BhpStockModel bhpStockModel = BhpStockModel(
      action: action,
      stok: int.parse(jumlah),
    );
    try {
      final res = await _repo.tambahStock(id, bhpStockModel);
      if (_streamBhpStock!.isClosed) return;
      bhpStockSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBhpStock!.isClosed) return;
      bhpStockSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamBhpStock!.close();
    _id.close();
    _action.close();
    _jumlah.close();
  }
}
