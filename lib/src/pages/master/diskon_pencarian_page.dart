import 'dart:io';

import 'package:admin_dokter_panggil/src/blocs/master_diskon_create_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_diskon_create_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiskonPencarianPage extends StatefulWidget {
  const DiskonPencarianPage({super.key});

  @override
  State<DiskonPencarianPage> createState() => _DiskonPencarianPageState();
}

class _DiskonPencarianPageState extends State<DiskonPencarianPage> {
  final _masterDiskonCreateBloc = MasterDiskonCreateBloc();
  final _filter = TextEditingController(text: '');
  final _filterFocus = FocusNode();
  bool _isStream = false;

  @override
  void initState() {
    super.initState();
    _masterDiskonCreateBloc.getMasterDiskon();
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    _masterDiskonCreateBloc.filterSink.add(_filter.text);
    _masterDiskonCreateBloc.getMasterDiskon();
    if (_filter.text.isEmpty) {
      _isStream = false;
    } else {
      _isStream = true;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _filter.dispose();
    _filterFocus.dispose();
    _masterDiskonCreateBloc.dispose();
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
                      controller: _filter,
                      focusNode: _filterFocus,
                      hint: 'Pencarian diskon',
                      autofocus: true,
                      suffixIcon: _isStream
                          ? InkWell(
                              onTap: () {
                                _filterFocus.requestFocus(FocusNode());
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
              child: _streamDiskonFilter(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _streamDiskonFilter(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterDiskonCreateModel>>(
      stream: _masterDiskonCreateBloc.masterDiskonStream,
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
              return _listMasterDiskon(context, snapshot.data!.data!.data!);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _listMasterDiskon(BuildContext context, List<MasterDiskon> data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      itemBuilder: (context, i) {
        var diskon = data[i];
        return ListTile(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context, diskon);
          },
          leading: const Icon(Icons.search),
          title: Text(diskon.deskripsi),
        );
      },
      itemCount: data.length,
    );
  }
}
