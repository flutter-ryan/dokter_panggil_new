import 'dart:async';

import 'package:dokter_panggil/src/blocs/master_village_bloc.dart';
import 'package:dokter_panggil/src/models/master_village_model.dart';
import 'package:dokter_panggil/src/pages/components/close_button_widget.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:flutter/material.dart';

class ListMasterVillagePage extends StatefulWidget {
  const ListMasterVillagePage({super.key});

  @override
  State<ListMasterVillagePage> createState() => _ListMasterVillagePageState();
}

class _ListMasterVillagePageState extends State<ListMasterVillagePage> {
  final _filter = TextEditingController();
  final _masterVillageBloc = MasterVillageBloc();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getMasterVillage();
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    _timer?.cancel();
    _masterVillageBloc.filterSink.add(_filter.text);
    if (_filter.text.length > 2) {
      _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
        _getMasterVillage();
        timer.cancel();
      });
    }
    if (_filter.text.isEmpty) {
      _timer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
        _getMasterVillage();
        timer.cancel();
      });
    }
  }

  void _getMasterVillage() {
    _masterVillageBloc.getMasterVillage();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _masterVillageBloc.dispose();
    _filter.removeListener(_filterListen);
    _filter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        minHeight: SizeConfig.blockSizeVertical * 60,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(22, 22, 22, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Pilih Kelurahan/Desa',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                CloseButtonWidget(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: SearchInputForm(
              controller: _filter,
              hint: 'Minimal 3 huruf depan kelurahan/desa',
              autocorrect: false,
              suffixIcon: _filter.text.isNotEmpty
                  ? CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.transparent,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _filter.clear();
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          )),
                    )
                  : null,
            ),
          ),
          Flexible(
            child: _streamMasterVillageWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _streamMasterVillageWidget(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterVillageModel>>(
      stream: _masterVillageBloc.masterVillageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: SizeConfig.blockSizeVertical * 30,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
                onTap: () => Navigator.pop(context),
              );
            case Status.completed:
              return ListView.separated(
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (context, i) {
                  Village kelurahan = snapshot.data!.data!.data![i];
                  return ListTile(
                    onTap: () => Navigator.pop(context, kelurahan),
                    contentPadding: EdgeInsets.symmetric(horizontal: 28),
                    title: Text(
                      '${kelurahan.name}',
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      '${kelurahan.propinsi!.nama} | ${kelurahan.kabupaten!.name} | ${kelurahan.kecamatan!.name}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded),
                  );
                },
                separatorBuilder: (context, i) => Divider(),
                itemCount: snapshot.data!.data!.data!.length,
              );
          }
        }
        return SizedBox(
          height: SizeConfig.blockSizeVertical * 60,
        );
      },
    );
  }
}
