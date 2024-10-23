import 'dart:async';

import 'package:dokter_panggil/src/models/master_role_model.dart';
import 'package:dokter_panggil/src/repositories/master_role_repo.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:rxdart/rxdart.dart';

class MasterRoleBloc {
  List<MasterRole> data = [];
  final _repo = MasterRoleRepo();
  StreamController<ApiResponse<List<MasterRole>>>? _streamMasterRole;
  StreamController<ApiResponse<ResponseMasterRoleRequestModel>>?
      _streaMasterRoleRequest;
  final BehaviorSubject<int> _idRole = BehaviorSubject();
  final BehaviorSubject<String> _deskripsi = BehaviorSubject();
  final BehaviorSubject<int> _role = BehaviorSubject();
  StreamSink<int> get idRoleSink => _idRole.sink;
  StreamSink<String> get deskripsiSink => _deskripsi.sink;
  StreamSink<int> get roleSink => _role.sink;
  StreamSink<ApiResponse<ResponseMasterRoleRequestModel>>
      get masterRoleRequestSink => _streaMasterRoleRequest!.sink;
  StreamSink<ApiResponse<List<MasterRole>>> get masterRoleSink =>
      _streamMasterRole!.sink;
  Stream<ApiResponse<List<MasterRole>>> get masterRoleStream =>
      _streamMasterRole!.stream;
  Stream<ApiResponse<ResponseMasterRoleRequestModel>>
      get masterRoleRequestStream => _streaMasterRoleRequest!.stream;

  Future<void> getMasterRole() async {
    _streamMasterRole = StreamController();
    masterRoleSink.add(ApiResponse.loading('Memuat...'));
    try {
      final res = await _repo.getMasterRole();
      if (_streamMasterRole!.isClosed) return;
      data = res.data!;
      masterRoleSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streamMasterRole!.isClosed) return;
      masterRoleSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<void> saveRole() async {
    _streaMasterRoleRequest = StreamController();
    final deskripsi = _deskripsi.value;
    final role = _role.value;
    masterRoleRequestSink.add(ApiResponse.loading('Memuat...'));
    MasterRoleRequestModel masterRoleRequestModel =
        MasterRoleRequestModel(deskripsi: deskripsi, role: role);
    try {
      final res = await _repo.saveMasterRole(masterRoleRequestModel);
      if (_streaMasterRoleRequest!.isClosed) return;
      data.add(res.data!);
      masterRoleRequestSink.add(ApiResponse.completed(res));
      masterRoleSink.add(ApiResponse.completed(data));
    } catch (e) {
      if (_streaMasterRoleRequest!.isClosed) return;
      masterRoleRequestSink.add(ApiResponse.error(e.toString()));
    }
  }

  dispose() {
    _streamMasterRole?.close();
    _streaMasterRoleRequest?.close();
    _idRole.close();
    _deskripsi.close();
    _role.close();
  }
}
