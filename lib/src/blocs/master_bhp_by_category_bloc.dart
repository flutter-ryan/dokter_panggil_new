import 'dart:async';

import 'package:admin_dokter_panggil/src/models/master_bhp_by_category_model.dart';
import 'package:admin_dokter_panggil/src/repositories/master_bhp_by_category_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/subjects.dart';

class MasterBhpByCategoryBloc {
  final _repo = MasterBhpByCategoryRepo();
  StreamController<ApiResponse<MasterBhpByCategoryModel>>? _streamBhpByCategory;
  final BehaviorSubject<int> _categoryId = BehaviorSubject();
  StreamSink<int> get categoryIdSink => _categoryId.sink;
  StreamSink<ApiResponse<MasterBhpByCategoryModel>> get bhpCategorySink =>
      _streamBhpByCategory!.sink;
  Stream<ApiResponse<MasterBhpByCategoryModel>> get bhpCategoryStream =>
      _streamBhpByCategory!.stream;

  Future<void> bhpByCategory() async {
    _streamBhpByCategory = StreamController();
    final categoryId = _categoryId.value;
    bhpCategorySink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getBhpByCategory(categoryId);
      if (_streamBhpByCategory!.isClosed) return;
      bhpCategorySink.add(ApiResponse.completed(res));
    } catch (e) {
      if (_streamBhpByCategory!.isClosed) return;
      bhpCategorySink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamBhpByCategory?.close();
    _categoryId.close();
  }
}
