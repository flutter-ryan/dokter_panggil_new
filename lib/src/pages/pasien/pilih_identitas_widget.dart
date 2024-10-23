import 'package:dokter_panggil/src/blocs/master_idenetitas_bloc.dart';
import 'package:dokter_panggil/src/models/master_identitas_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/marker_bottom_sheet.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PilihIdentitasWidget extends StatefulWidget {
  const PilihIdentitasWidget({
    super.key,
    this.pasien,
  });

  final Pasien? pasien;

  @override
  State<PilihIdentitasWidget> createState() => _PilihIdentitasWidgetState();
}

class _PilihIdentitasWidgetState extends State<PilihIdentitasWidget> {
  final _masterIdentitasBloc = MasterIdentitasBloc();
  final _nomor = TextEditingController();
  int _selectedJenis = 0;
  @override
  void initState() {
    super.initState();
    _getMasterIdentitas();
    if (widget.pasien?.identitas != null && widget.pasien != null) {
      _nomor.text = '${widget.pasien!.identitas!.nomorIdentitas}';
      setState(() {
        _selectedJenis = widget.pasien!.identitas!.identitas!.id!;
      });
    } else if (widget.pasien != null) {
      _nomor.text = '${widget.pasien!.nik}';
    }
  }

  void _getMasterIdentitas() {
    _masterIdentitasBloc.getMasterIdentitas();
  }

  void _konfirmasi() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_nomor.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Nomor identitas tidak boleh kosong',
        backgroundColor: Colors.red.withOpacity(0.8),
      );
      return;
    }
    if (_selectedJenis == 0) {
      Fluttertoast.showToast(
        msg: 'Silahkan pilih jenis identitas terlebih dahulu',
        backgroundColor: Colors.red.withOpacity(0.8),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PilihIdentitasModel pilihIdentitasModel =
          PilihIdentitasModel(id: _selectedJenis, nomor: _nomor.text);
      Navigator.pop(context, pilihIdentitasModel);
    });
  }

  @override
  void dispose() {
    _nomor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: SizeConfig.blockSizeVertical * 93,
          minHeight: SizeConfig.blockSizeVertical * 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: MarkerBottomSheet(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 22.0),
            child: Text(
              'Input nomor identitas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Input(
              controller: _nomor,
              label: 'Nomor',
              hint: 'Ketikkan nomor identitas sesuai pilihan',
              maxLines: 1,
              keyType: TextInputType.number,
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0),
            child: Text(
              'Pilih jenis identitas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: _buildStreamMasterIdentitas(context),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 32, 22, 0),
              child: ElevatedButton(
                onPressed: _konfirmasi,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Kofirmasi Identitas'),
              ),
            ),
          ),
          const SizedBox(
            height: 32.0,
          )
        ],
      ),
    );
  }

  Widget _buildStreamMasterIdentitas(BuildContext context) {
    return StreamBuilder<ApiResponse<List<MasterIdentitas>>>(
      stream: _masterIdentitasBloc.masterIdentitasStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 80,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _getMasterIdentitas();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  itemBuilder: (context, i) {
                    var identitas = snapshot.data!.data![i];
                    return ListTile(
                      onTap: () => setState(() {
                        _selectedJenis = identitas.id!;
                      }),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 4),
                      title: Text('${identitas.jenis}'),
                      minLeadingWidth: 0,
                      leading: const Icon(Icons.arrow_right_rounded),
                      trailing: _selectedJenis == identitas.id
                          ? const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.red,
                            )
                          : null,
                    );
                  },
                  separatorBuilder: (context, i) => const Divider(
                        height: 0,
                      ),
                  itemCount: snapshot.data!.data!.length);
          }
        }
        return const SizedBox();
      },
    );
  }
}

class PilihIdentitasModel {
  PilihIdentitasModel({
    required this.id,
    required this.nomor,
  });

  int id;
  String nomor;
}
