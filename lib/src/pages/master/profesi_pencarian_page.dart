import 'dart:io';

import 'package:admin_dokter_panggil/src/blocs/profesi_filter_bloc.dart';
import 'package:admin_dokter_panggil/src/models/profesi_filter_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';

class ProfesiPencarianPage extends StatefulWidget {
  const ProfesiPencarianPage({super.key});

  @override
  State<ProfesiPencarianPage> createState() => _ProfesiPencarianPageState();
}

class _ProfesiPencarianPageState extends State<ProfesiPencarianPage> {
  final ProfesiFilterBloc _profesiFilterBloc = ProfesiFilterBloc();
  final _filterCon = TextEditingController();
  final _filterFocus = FocusNode();
  bool _isStream = false;

  @override
  void initState() {
    super.initState();
    _getProfesi();
    _filterCon.addListener(_inputListener);
  }

  void _getProfesi() {
    _profesiFilterBloc.filterProfesi();
  }

  void _inputListener() {
    if (_filterCon.text.isNotEmpty) {
      _profesiFilterBloc.filterSink.add(_filterCon.text);
      _profesiFilterBloc.filterProfesi();
      setState(() {});
    } else {
      _getProfesi();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _filterCon.dispose();
    _filterFocus.dispose();
    _profesiFilterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
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
                      controller: _filterCon,
                      focusNode: _filterFocus,
                      hint: 'Pencarian profesi',
                      autofocus: true,
                      suffixIcon: _isStream
                          ? InkWell(
                              onTap: () {
                                _filterFocus.requestFocus(FocusNode());
                                setState(() {
                                  _filterCon.clear();
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
            _buildStreamFilter()
          ],
        ),
      ),
    );
  }

  Widget _buildStreamFilter() {
    return StreamBuilder<ApiResponse<ResponseProfesiFilterModel>>(
      stream: _profesiFilterBloc.profesiFilterStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const LoadingKit(
                color: kPrimaryColor,
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () {
                  _profesiFilterBloc.filterProfesi();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: snapshot.data!.data!.profesi!.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data!.profesi![i];
                  return ListTile(
                    onTap: () => Navigator.pop(context, data),
                    leading: const Icon(Icons.search),
                    title: Text('${data.namaJabatan}'),
                  );
                },
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}
