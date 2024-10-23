import 'dart:async';
import 'dart:io';

import 'package:dokter_panggil/src/blocs/master_paket_create_bloc.dart';
import 'package:dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';

class PaketPencarianPage extends StatefulWidget {
  const PaketPencarianPage({super.key});

  @override
  State<PaketPencarianPage> createState() => _PaketPencarianPageState();
}

class _PaketPencarianPageState extends State<PaketPencarianPage> {
  final _masterPaketCreateBloc = MasterPaketCreateBloc();
  final _filter = TextEditingController();
  final _filterFocus = FocusNode();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getPaket();
    _filter.addListener(_inputListener);
    Future.delayed(const Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(_filterFocus);
    });
  }

  void _getPaket() {
    _masterPaketCreateBloc.getMasterPaket();
  }

  void _inputListener() {
    _timer?.cancel();
    if (_filter.text.isNotEmpty && _filter.text.length < 3) return;
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _masterPaketCreateBloc.filterSink.add(_filter.text);
      _masterPaketCreateBloc.getMasterPaket();
      timer.cancel();
      setState(() {
        _timer = timer;
      });
    });
  }

  void _close() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(const Duration(milliseconds: 400), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _filter.dispose();
    _filterFocus.dispose();
    _filter.removeListener(_inputListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: _close,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[600],
                    ),
                  )
                else
                  IconButton(
                    onPressed: _close,
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
                    hint: 'Pencarian paket/promo',
                    suffixIcon: _filter.text.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _filterFocus.requestFocus(FocusNode());
                              _filter.clear();
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
            height: 12.0,
          ),
          Expanded(child: _streamMasterPaket(context))
        ],
      ),
    );
  }

  Widget _streamMasterPaket(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterPaketCreateModel>>(
      stream: _masterPaketCreateBloc.masterPaketCreateStream,
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
                  _getPaket();
                  setState(() {});
                },
              );
            case Status.completed:
              return ListPaket(
                data: snapshot.data!.data!.data,
              );
          }
        }
        return const SizedBox();
      },
    );
  }
}

class ListPaket extends StatefulWidget {
  const ListPaket({
    super.key,
    this.data,
  });

  final List<MasterPaket>? data;

  @override
  State<ListPaket> createState() => _ListPaketState();
}

class _ListPaketState extends State<ListPaket> {
  List<MasterPaket> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
  }

  @override
  void didUpdateWidget(covariant ListPaket oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        _data = widget.data!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Text(
            'Hasil pencarian:',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 0),
            itemBuilder: (context, i) {
              var paket = _data[i];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 22.0),
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  FocusScope.of(context).requestFocus(FocusNode());
                  Future.delayed(
                    const Duration(milliseconds: 200),
                    () => Navigator.pop(context, paket),
                  );
                },
                leading: const Icon(Icons.search),
                title: Text('${paket.namaPaket}'),
                minLeadingWidth: 28,
              );
            },
            separatorBuilder: (context, i) => const Divider(
              height: 0.0,
            ),
            itemCount: _data.length,
          ),
        ),
      ],
    );
  }
}
