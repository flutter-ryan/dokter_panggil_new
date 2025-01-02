import 'dart:async';
import 'dart:io';

import 'package:dokter_panggil/src/blocs/mitra_filter_bloc.dart';
import 'package:dokter_panggil/src/models/mitra_filter_model.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class MitraPencarianPage extends StatefulWidget {
  const MitraPencarianPage({super.key});

  @override
  State<MitraPencarianPage> createState() => _MitraPencarianPageState();
}

class _MitraPencarianPageState extends State<MitraPencarianPage> {
  final MitraFilterBloc _mitraFilterBloc = MitraFilterBloc();
  final _filterCon = TextEditingController();
  final _filterFocus = FocusNode();
  bool _isStream = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getProfesi();
    _filterCon.addListener(_inputListener);
  }

  void _getProfesi() {
    _mitraFilterBloc.filterSink.add(_filterCon.text);
    _mitraFilterBloc.filterMitra();
  }

  void _inputListener() {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(const Duration(milliseconds: 1000), () {
      _getProfesi();
      if (_filterCon.text.isNotEmpty) {
        setState(() {
          _isStream = true;
        });
      } else {
        setState(() {
          _isStream = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _filterCon.dispose();
    _filterFocus.dispose();
    _mitraFilterBloc.dispose();
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
                      hint: 'Pencarian mitra',
                      autofocus: true,
                      suffixIcon: _isStream
                          ? InkWell(
                              onTap: () {
                                _filterFocus.requestFocus(FocusNode());
                                setState(() {
                                  _filterCon.clear();
                                  _isStream = false;
                                });
                                _getProfesi();
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
            Expanded(child: _buildStreamFilter(context))
          ],
        ),
      ),
    );
  }

  Widget _buildStreamFilter(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMitraFilterModel>>(
      stream: _mitraFilterBloc.filterMitraStream,
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
                  _filterFocus.requestFocus(FocusNode());
                  setState(() {
                    _filterCon.clear();
                    _isStream = false;
                  });
                  _getProfesi();
                },
              );
            case Status.completed:
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: snapshot.data!.data!.mitra!.length,
                itemBuilder: (context, i) {
                  var data = snapshot.data!.data!.mitra![i];
                  return ListTile(
                    onTap: () => Navigator.pop(context, data),
                    leading: const Icon(Icons.search),
                    title: Text('${data.namaMitra}'),
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
