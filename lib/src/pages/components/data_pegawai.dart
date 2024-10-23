import 'package:dokter_panggil/src/blocs/pegawai_edit_bloc.dart';
import 'package:dokter_panggil/src/models/master_pegawai_fetch_model.dart';
import 'package:dokter_panggil/src/models/pegawai_edit_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class StreamShowPegawai extends StatefulWidget {
  const StreamShowPegawai({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<StreamShowPegawai> createState() => _StreamShowPegawaiState();
}

class _StreamShowPegawaiState extends State<StreamShowPegawai> {
  final PegawaiEditBloc _pegawaiEditBloc = PegawaiEditBloc();

  @override
  void initState() {
    super.initState();
    _pegawaiEditBloc.idSink.add(widget.id);
    _pegawaiEditBloc.editPegawai();
  }

  void _editPegawai(MasterPegawai pegawai) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Container();
      },
    );
  }

  void _editAkun(User? user) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Container();
      },
    );
  }

  void _editSip(Sip? sip) {
    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _pegawaiEditBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<PegawaiEditModel>>(
      stream: _pegawaiEditBloc.pegawaiEditStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Center(
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _pegawaiEditBloc.editPegawai();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return _profilePegawai(snapshot.data!.data!.pegawai);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _profilePegawai(MasterPegawai? pegawai) {
    return ListView(
      padding: const EdgeInsets.all(32.0),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset('images/logo_only.png'),
            ),
            const SizedBox(
              width: 22.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${pegawai!.nama}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text('${pegawai.profesi!.namaJabatan}'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 42.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profil Pegawai',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
            ),
            const SizedBox(
              height: 22.0,
            ),
            ListTile(
              onTap: () => _editPegawai(pegawai),
              contentPadding: EdgeInsets.zero,
              title: const Text('Informasi pegawai'),
              subtitle: const Text('Atur informasi umum pegawai'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
            ),
            const Divider(
              height: 18,
            ),
            if (pegawai.profesi!.id == 4)
              ListTile(
                onTap: () => _editSip(pegawai.sip),
                contentPadding: EdgeInsets.zero,
                title: const Text('Informasi SIP Dokter'),
                subtitle: const Text('Atur informasi SIP Dokter'),
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
              ),
            if (pegawai.profesi!.id == 4)
              const Divider(
                height: 18,
              ),
            ListTile(
              onTap: () => _editAkun(pegawai.user),
              contentPadding: EdgeInsets.zero,
              title: const Text('Informasi akun'),
              subtitle: const Text('Atur informasi akun masuk pegawai'),
              trailing: const Icon(Icons.keyboard_arrow_right_rounded),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _formPegawai(BuildContext context) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Edit Data Pegawai',
  //         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
  //       ),
  //       SizedBox(
  //         height: 18.0,
  //       ),
  //       Input(
  //         controller: _nama,
  //         label: 'Nama',
  //         hint: 'Nama lengkap pegawai',
  //         maxLines: 1,
  //         validator: (val) {
  //           if (val!.isEmpty) {
  //             return 'Input required';
  //           }
  //           return null;
  //         },
  //         textCap: TextCapitalization.words,
  //         textInputAction: TextInputAction.next,
  //       ),
  //       const SizedBox(
  //         height: 22.0,
  //       ),
  //       Input(
  //         controller: _profesi,
  //         label: 'Profesi',
  //         hint: 'Pilih profesi',
  //         maxLines: 1,
  //         suffixIcon: AnimateIcons(
  //           startIconColor: Colors.grey,
  //           endIconColor: Colors.grey,
  //           startIcon: Icons.expand_more_rounded,
  //           endIcon: Icons.expand_less_rounded,
  //           duration: const Duration(milliseconds: 300),
  //           onStartIconPress: () {
  //             _showJabatan();
  //             return false;
  //           },
  //           onEndIconPress: () {
  //             Navigator.pop(context);
  //             return false;
  //           },
  //           controller: _animateIconController,
  //         ),
  //         validator: (val) {
  //           if (val!.isEmpty) {
  //             return 'Input required';
  //           }
  //           return null;
  //         },
  //         readOnly: true,
  //         onTap: _showJabatan,
  //       ),
  //     ],
  //   );
  // }
}
