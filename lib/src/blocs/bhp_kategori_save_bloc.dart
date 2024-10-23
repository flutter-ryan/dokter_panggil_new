import 'dart:async';

import 'package:dokter_panggil/src/models/bhp_kategori_save_model.dart';
import 'package:dokter_panggil/src/repositories/bhp_kategori_save_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class BhpKategoriSaveBloc {
  final _repo = BhpKategoriSaveRepo();
  late StreamController<ApiResponse<ResponseBhpKategoriSaveModel>>
      _streamBhpKategoriSave;

  final BehaviorSubject<int> _id = BehaviorSubject();
  final BehaviorSubject<String> _kategori = BehaviorSubject();
  StreamSink<int> get idSink => _id.sink;
  StreamSink<String> get kategoriSink => _kategori.sink;
  StreamSink<ApiResponse<ResponseBhpKategoriSaveModel>>
      get bhpKategoriSaveSink => _streamBhpKategoriSave.sink;
  Stream<ApiResponse<ResponseBhpKategoriSaveModel>> get bhpKategoriSaveStream =>
      _streamBhpKategoriSave.stream;

  Future<void> saveKategori() async {
    _streamBhpKategoriSave = StreamController();
    final kategori = _kategori.value;
    bhpKategoriSaveSink.add(ApiResponse.loading('Memuat...'));
    BhpKategoriSaveModel bhpKategoriSaveModel =
        BhpKategoriSaveModel(kategori: kategori);

    try {
      final res = await _repo.saveKategori(bhpKategoriSaveModel);
      if (_streamBhpKategoriSave.isClosed) return;
      bhpKategoriSaveSink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBhpKategoriSave.isClosed) return;
      bhpKategoriSaveSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _id.close();
    _kategori.close();
    _streamBhpKategoriSave.close();
  }
}
