import 'dart:async';

import 'package:admin_dokter_panggil/src/models/mr_menu_model.dart';
import 'package:admin_dokter_panggil/src/repositories/mr_menu_repo.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/menu_mr.dart';
import 'package:rxdart/rxdart.dart';

class MrMenuBloc {
  final _repo = MrMenuRepo();
  StreamController<ApiResponse<List<MrMenu>>>? _streamMrMenu;
  final BehaviorSubject<int> _idKunjungan = BehaviorSubject();
  StreamSink<int> get idKunjunganSink => _idKunjungan.sink;
  StreamSink<ApiResponse<List<MrMenu>>> get mrMenuSink => _streamMrMenu!.sink;
  Stream<ApiResponse<List<MrMenu>>> get mrMenuStream => _streamMrMenu!.stream;

  Future<void> getMrMenu() async {
    _streamMrMenu = StreamController();
    final idKunjungan = _idKunjungan.value;
    List<MrMenu> showMenus = menus;
    mrMenuSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMrMenu(idKunjungan);
      if (_streamMrMenu!.isClosed) return;
      final Set<int> activeIds = res.data!.map<int>((e) => e.id!).toSet();
      showMenus = menus.map((menu) {
        final isVisible = activeIds.contains(menu.id);
        return menu.copyWith(visible: isVisible);
      }).toList();
      await Future.delayed((Duration(milliseconds: 500)));
      mrMenuSink.add(ApiResponse.completed(showMenus));
    } catch (e) {
      if (_streamMrMenu!.isClosed) return;
      mrMenuSink.add(ApiResponse.error(e.toString()));
    }
  }

  void dispose() {
    _streamMrMenu?.close();
    _idKunjungan.close();
  }
}
