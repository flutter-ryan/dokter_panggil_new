import 'package:dokter_panggil/src/blocs/master_tindakan_bloc.dart';
import 'package:dokter_panggil/src/models/master_tindakan_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class ListMasterTindakan extends StatefulWidget {
  const ListMasterTindakan({
    super.key,
    this.selectedData,
  });

  final List<MasterTindakan>? selectedData;

  @override
  State<ListMasterTindakan> createState() => _ListMasterTindakanState();
}

class _ListMasterTindakanState extends State<ListMasterTindakan> {
  final MasterTindakanBloc _masterTindakanBloc = MasterTindakanBloc();

  @override
  void initState() {
    super.initState();
    _masterTindakanBloc.fetchMasterTindakan();
  }

  @override
  void dispose() {
    _masterTindakanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterTindakanModel>>(
      stream: _masterTindakanBloc.masterTindakanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 180,
                child: Center(
                  child: LoadingKit(
                    color: kPrimaryColor,
                  ),
                ),
              );
            case Status.error:
              return SizedBox(
                width: double.infinity,
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  button: false,
                ),
              );
            case Status.completed:
              return ListTindakan(data: snapshot.data!.data!.data);
          }
        }
        return const SizedBox(
          height: 180,
        );
      },
    );
  }
}

class ListTindakan extends StatefulWidget {
  const ListTindakan({
    super.key,
    this.data,
  });

  final List<MasterTindakan>? data;

  @override
  State<ListTindakan> createState() => _ListTindakanState();
}

class _ListTindakanState extends State<ListTindakan> {
  final _filter = TextEditingController();
  List<MasterTindakan> _data = [];

  @override
  void initState() {
    super.initState();
    _data = widget.data!;
    _filter.addListener(_filterListen);
  }

  void _filterListen() {
    if (_filter.text.isEmpty) {
      _data = widget.data!;
    } else {
      _data = widget.data!
          .where(
            (e) => e.namaTindakan!
                .toLowerCase()
                .contains(_filter.text.toLowerCase()),
          )
          .toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _filter.removeListener(_filterListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 25.0),
          child: Text(
            'Daftar Tindakan',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: SearchInputForm(
            controller: _filter,
            hint: "Pencarian nama tindakan",
            suffixIcon: _filter.text.isNotEmpty
                ? InkWell(
                    onTap: () {
                      _filter.clear();
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
        ),
        Expanded(
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              itemBuilder: (context, i) {
                var data = _data[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25.0),
                  title: Text('${data.namaTindakan}'),
                  // trailing: const Icon(
                  //   Icons.check_circle_outline_rounded,
                  //   color: Colors.green,
                  // ),
                );
              },
              separatorBuilder: (context, i) => const Divider(
                    height: 0,
                  ),
              itemCount: _data.length),
        ),
      ],
    );
  }
}
