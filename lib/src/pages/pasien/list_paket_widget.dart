import 'dart:async';

import 'package:admin_dokter_panggil/src/blocs/master_paket_create_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_paket_create_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/button_circle_widget.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListPaketWidget extends StatefulWidget {
  const ListPaketWidget({
    super.key,
    this.selectedId,
  });

  final int? selectedId;

  @override
  State<ListPaketWidget> createState() => _ListPaketWidgetState();
}

class _ListPaketWidgetState extends State<ListPaketWidget> {
  final _masterPaketCreateBloc = MasterPaketCreateBloc();
  final _filter = TextEditingController();
  bool _isStream = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _filter.addListener(_filterListen);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Future.delayed(const Duration(milliseconds: 500), () {
        _filterPaket();
      }),
    );
  }

  void _filterListen() {
    _timer?.cancel();
    if (_filter.text.isNotEmpty && _filter.text.length > 2) {
      _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        setState(() {
          _isStream = false;
        });
        _filterPaket();
        timer.cancel();
      });
    }
    if (_filter.text.isEmpty) {
      setState(() {
        _isStream = false;
      });
      _filterPaket();
    }
  }

  void _filterPaket() {
    _masterPaketCreateBloc.filterSink.add(_filter.text);
    _masterPaketCreateBloc.getMasterPaket();
    setState(() {
      _isStream = true;
    });
  }

  void _selectedPaket(MasterPaket data) async {
    if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
      await Future.delayed(const Duration(milliseconds: 500));
    }
    if (!mounted) return;
    Navigator.pop(
      context,
      SelectedPaketModel(
        id: data.id,
        namaPaket: data.namaPaket,
        isPerawat: data.consumes!.isNotEmpty,
      ),
    );
  }

  @override
  void dispose() {
    _masterPaketCreateBloc.dispose();
    _filter.removeListener(_filterListen);
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(22.0, 32, 22.0, 0.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Daftar paket',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              ButtonCircleWidget(
                icon: Icon(
                  Icons.close,
                  size: 18,
                ),
                bgColor: Colors.grey[100],
                fgColor: Colors.grey,
                radius: 18,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: SearchInputForm(
            controller: _filter,
            hint: 'Pencarian nama paket',
            autocorrect: false,
            suffixIcon: _filter.text.isNotEmpty && _filter.text.length > 2
                ? CircleAvatar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey[400],
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _filter.clear(),
                      icon: Icon(Icons.cancel_outlined),
                    ),
                  )
                : null,
          ),
        ),
        Expanded(
            child: _isStream
                ? _buildStreamMasterWidget(context)
                : Center(
                    child: LoadingKit(
                      color: kPrimaryColor,
                    ),
                  ))
      ],
    );
  }

  Widget _buildStreamMasterWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<ResponseMasterPaketCreateModel>>(
      stream: _masterPaketCreateBloc.masterPaketCreateStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 200,
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
                      _masterPaketCreateBloc.getMasterPaket();
                      setState(() {});
                    },
                  ),
                ),
              );
            case Status.completed:
              return SafeArea(
                top: false,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    var data = snapshot.data!.data!.data![i];
                    return ListTile(
                      onTap: () => _selectedPaket(data),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 32),
                      title: Text('${data.namaPaket}'),
                      titleTextStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0),
                      trailing: widget.selectedId == data.id
                          ? const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.green,
                            )
                          : const SizedBox(
                              width: 22.0,
                            ),
                    );
                  },
                  separatorBuilder: (context, i) => const Divider(
                    height: 0,
                  ),
                  itemCount: snapshot.data!.data!.data!.length,
                ),
              );
          }
        }
        return const SizedBox(
          height: 200,
        );
      },
    );
  }
}

class SelectedPaketModel {
  SelectedPaketModel({
    this.id,
    this.namaPaket,
    this.isPerawat = false,
  });

  int? id;
  String? namaPaket;
  bool isPerawat;
}
