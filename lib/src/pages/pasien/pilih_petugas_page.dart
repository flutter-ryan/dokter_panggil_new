import 'dart:async';

import 'package:dokter_panggil/src/blocs/pegawai_profesi_bloc.dart';
import 'package:dokter_panggil/src/models/pegawai_dokter_model.dart';
import 'package:dokter_panggil/src/pages/components/button_circle_widget.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class PilihPetugasPage extends StatefulWidget {
  const PilihPetugasPage({
    super.key,
    this.idGroup = 1,
  });

  final int idGroup;

  @override
  State<PilihPetugasPage> createState() => _PilihPetugasPageState();
}

class _PilihPetugasPageState extends State<PilihPetugasPage> {
  final _pegawaiProfesiBloc = PegawaiProfesiBloc();
  final _filter = TextEditingController();
  bool _isStream = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _filter.addListener(_filterListen);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(
        const Duration(milliseconds: 500),
        () => _filterPegawai(),
      ),
    );
  }

  void _filterPegawai() {
    _pegawaiProfesiBloc.groupIdSink.add(widget.idGroup);
    _pegawaiProfesiBloc.filtersink.add(_filter.text);
    _pegawaiProfesiBloc.filterPegawaiProfesi();
    setState(() {
      _isStream = true;
    });
  }

  void _filterListen() {
    _timer?.cancel();
    if (_filter.text.isNotEmpty && _filter.text.length > 2) {
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          _isStream = false;
        });
        _filterPegawai();
        timer.cancel();
      });
    }
    if (_filter.text.isEmpty) {
      setState(() {
        _isStream = false;
      });
      _filterPegawai();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _filter.removeListener(_filterListen);
    _filter.dispose();
    _pegawaiProfesiBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Pilih Petugas',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ButtonCircleWidget(
                radius: 18,
                icon: Icon(
                  Icons.close_rounded,
                  size: 18,
                ),
                bgColor: Colors.grey[100],
                fgColor: Colors.grey[400],
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(22),
          child: SearchInputForm(
            controller: _filter,
            hint: 'Pencarian nama petugas',
            autocorrect: false,
          ),
        ),
        Expanded(
          child: _isStream
              ? _buildStreamPegawai(context)
              : Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
        )
      ],
    );
  }

  Widget _buildStreamPegawai(BuildContext context) {
    return StreamBuilder<ApiResponse<PegawaiProfesiModel>>(
      stream: _pegawaiProfesiBloc.pegawaiProfesiStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 150,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return SizedBox(
                height: 250,
                child: Center(
                  child: ErrorResponse(
                    message: snapshot.data!.message,
                    onTap: () {
                      _pegawaiProfesiBloc.pegawaiProfesi();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data!.profesi![i];
                  return ListTile(
                    onTap: () => Navigator.pop(context, data),
                    contentPadding: EdgeInsets.zero,
                    title: Text('${data.nama}'),
                  );
                },
                separatorBuilder: (context, i) => const Divider(
                  height: 0,
                ),
                itemCount: snapshot.data!.data!.profesi!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
