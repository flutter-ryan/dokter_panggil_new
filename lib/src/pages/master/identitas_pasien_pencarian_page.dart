import 'dart:async';
import 'dart:io';

import 'package:admin_dokter_panggil/src/blocs/master_idenetitas_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_identitas_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IdentitasPasienPencarianPage extends StatefulWidget {
  const IdentitasPasienPencarianPage({super.key});

  @override
  State<IdentitasPasienPencarianPage> createState() =>
      _IdentitasPasienPencarianPageState();
}

class _IdentitasPasienPencarianPageState
    extends State<IdentitasPasienPencarianPage> {
  final _masterIdentitasBloc = MasterIdentitasBloc();
  final _filter = TextEditingController();
  bool _isStream = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _filter.text = '';
    _filter.addListener(_filterListen);
    _getIdentitas();
  }

  void _getIdentitas() {
    _masterIdentitasBloc.filterSink.add(_filter.text);
    _masterIdentitasBloc.getMasterIdentitas();
  }

  void _filterListen() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _getIdentitas();
      timer.cancel();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 2.0,
                right: 32.0,
                top: MediaQuery.of(context).padding.top + 18,
              ),
              child: Row(
                children: [
                  if (Platform.isAndroid)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey[600],
                      ),
                    )
                  else
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Expanded(
                    child: SearchInputForm(
                      controller: _filter,
                      hint: 'Pencarian jenis identitas',
                      autofocus: true,
                      suffixIcon: _isStream
                          ? InkWell(
                              onTap: () {
                                _filter.clear();
                                setState(() {
                                  _isStream = false;
                                });
                              },
                              child: FaIcon(
                                FontAwesomeIcons.circleXmark,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 22.0,
            ),
            Expanded(
              child: _buildStreamIdentitas(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStreamIdentitas(BuildContext context) {
    return StreamBuilder<ApiResponse<List<MasterIdentitas>>>(
      stream: _masterIdentitasBloc.masterIdentitasStream,
      builder: (contex, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return Padding(
                padding: const EdgeInsets.all(32),
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _getIdentitas();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 22.0, vertical: 12.0),
                itemBuilder: (context, i) {
                  var identitas = snapshot.data!.data![i];
                  return ListTile(
                    onTap: () => Navigator.pop(context, identitas),
                    leading: SvgPicture.asset('images/search.svg'),
                    title: Text('${identitas.jenis}'),
                  );
                },
                separatorBuilder: (context, i) => const SizedBox(
                  height: 18.0,
                ),
                itemCount: snapshot.data!.data!.length,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
