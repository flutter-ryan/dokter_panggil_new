import 'dart:io';

import 'package:dokter_panggil/src/blocs/diagnosa_filter_bloc.dart';
import 'package:dokter_panggil/src/models/diagnosa_filter_model.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiagnosaPencarianPage extends StatefulWidget {
  const DiagnosaPencarianPage({Key? key}) : super(key: key);

  @override
  State<DiagnosaPencarianPage> createState() => _DiagnosaPencarianPageState();
}

class _DiagnosaPencarianPageState extends State<DiagnosaPencarianPage> {
  final DiagnosaFilterBloc _diagnosaFilterBloc = DiagnosaFilterBloc();
  final _filterCon = TextEditingController();
  final _filterFocus = FocusNode();
  bool _isStream = false;
  @override
  void initState() {
    super.initState();
    _getFilter();
    _filterCon.addListener(_inputListener);
  }

  void _getFilter() {
    _diagnosaFilterBloc.filterDiagnosa();
  }

  void _inputListener() {
    if (_filterCon.text.isNotEmpty) {
      _diagnosaFilterBloc.filterSink.add(_filterCon.text);
      _diagnosaFilterBloc.filterDiagnosa();
      setState(() {
        _isStream = true;
      });
    } else {
      _getFilter();
      setState(() {
        _isStream = false;
      });
    }
  }

  @override
  void dispose() {
    _filterCon.dispose();
    _filterFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
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
                      hint: 'Pencarian tindakan',
                      autofocus: true,
                      suffixIcon: _isStream
                          ? InkWell(
                              onTap: () {
                                _filterFocus.requestFocus(FocusNode());
                                _filterCon.clear();
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
              child: _buildStreamFilter(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStreamFilter() {
    return StreamBuilder<ApiResponse<ResponseDiagnosaFilterModel>>(
      stream: _diagnosaFilterBloc.diagnosaFilterStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 15.0,
                  child: CircularProgressIndicator(),
                ),
              );
            case Status.error:
              return Center(
                child: Text(
                  snapshot.data!.message,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            case Status.completed:
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: snapshot.data!.data!.diagnosa!.length,
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data!.diagnosa![i];
                  return ListTile(
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.pop(context, data);
                    },
                    leading: const Icon(Icons.search),
                    title: Text('${data.namaDiagnosa}'),
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
