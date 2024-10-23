import 'dart:async';

import 'package:dokter_panggil/src/blocs/kunjungan_pasien_resume_bloc.dart';
import 'package:dokter_panggil/src/models/kunjungan_pasien_resume_model.dart';
import 'package:dokter_panggil/src/models/pasien_show_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/pasien/timeline_kunjungan_resume.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class NewRiwayatPasien extends StatefulWidget {
  const NewRiwayatPasien({
    super.key,
    this.pasien,
  });

  final Pasien? pasien;

  @override
  State<NewRiwayatPasien> createState() => _NewRiwayatPasienState();
}

class _NewRiwayatPasienState extends State<NewRiwayatPasien> {
  final _controller = ScrollController();
  final _kunjunganResumePasienBloc = KunjunganResumePasienBloc();
  final _filter = TextEditingController();
  final _filterFocus = FocusNode();
  DateTime _selectedDate = DateTime.now();
  final _tanggal = DateFormat('yyyy-MM-dd', 'id');
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _kunjunganResumePasienBloc.normSink.add('${widget.pasien!.norm}');
    _kunjunganResumePasienBloc.getKunjunganPasienResume();
    _controller.addListener(_listenScroll);
    _filter.addListener(_pencarianListen);
  }

  void _pencarianListen() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _kunjunganResumePasienBloc.tanggalSink.add(_filter.text);
      _kunjunganResumePasienBloc.getKunjunganPasienResume();
      _timer?.cancel();
      setState(() {});
    });
  }

  void _listenScroll() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      _kunjunganResumePasienBloc.normSink.add('${widget.pasien!.norm}');
      _kunjunganResumePasienBloc.getNextKunjunganPasienResume();
    }
  }

  void _showDate() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih tanggal kunjungan',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      fieldLabelText: 'Tanggal Kunjungan',
      fieldHintText: 'Tanggal/Bulan/Tahun',
    ).then((picked) {
      if (picked != null) {
        _filter.text = _tanggal.format(picked);
        setState(() {
          _selectedDate = picked;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _kunjunganResumePasienBloc.dispose();
    _filter.removeListener(_pencarianListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: kPrimaryColor, boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                )
              ]),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[300],
                      child: Center(
                        child: Image.asset('images/logo_only.png'),
                      ),
                    ),
                    title: Text(
                      '${widget.pasien!.namaPasien}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      'RM${widget.pasien!.normSprint} - ${widget.pasien!.umur}',
                      style: TextStyle(color: Colors.grey[300], fontSize: 14.0),
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.grey[300],
                      radius: 15,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close_rounded),
                        iconSize: 22,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(18.0),
                    child: SearchInputForm(
                      controller: _filter,
                      focusNode: _filterFocus,
                      isReadOnly: true,
                      hint: 'Pilih tanggal kunjungan',
                      onTap: _showDate,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_filter.text.isNotEmpty)
                            InkWell(
                              onTap: () {
                                _filter.clear();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: FaIcon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          InkWell(
                            onTap: _showDate,
                            child: FaIcon(
                              FontAwesomeIcons.calendar,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildStreamRiwayatKunjungan(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStreamRiwayatKunjungan(BuildContext context) {
    return StreamBuilder<ApiResponse<KunjunganPasienResumeModel>>(
      stream: _kunjunganResumePasienBloc.kunjunganPasienResumeStream,
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
              return Center(
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  button: false,
                ),
              );
            case Status.completed:
              return TimelineKunjuganResume(
                controller: _controller,
                data: snapshot.data!.data!,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
