import 'package:dokter_panggil/src/blocs/mitra_filter_bloc.dart';
import 'package:dokter_panggil/src/models/mitra_filter_model.dart';
import 'package:dokter_panggil/src/pages/components/error_response.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class MitraSelect extends StatefulWidget {
  const MitraSelect({
    Key? key,
    required this.jenis,
  }) : super(key: key);

  final String jenis;

  @override
  State<MitraSelect> createState() => _MitraSelectState();
}

class _MitraSelectState extends State<MitraSelect> {
  final MitraFilterBloc _mitraFilterBloc = MitraFilterBloc();

  @override
  void initState() {
    super.initState();
    _mitraFilterBloc.jenisSink.add(widget.jenis);
    _mitraFilterBloc.filterMitra();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 22.0),
          child: Text(
            'Pilih mitra',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          ),
        ),
        const Divider(
          height: 8.0,
        ),
        _streamListMitra(),
      ],
    );
  }

  Widget _streamListMitra() {
    return StreamBuilder<ApiResponse<ResponseMitraFilterModel>>(
      stream: _mitraFilterBloc.filterMitraStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return const SizedBox(
                height: 150,
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return ErrorResponse(
                message: snapshot.data!.message,
              );
            case Status.completed:
              return _listMitra(snapshot.data!.data!.mitra);
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _listMitra(List<MitraFilter>? mitra) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 22.0, top: 0.0),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        var data = mitra[i];
        return ListTile(
          onTap: () => Navigator.pop(context, data),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
          title: Text('${data.namaMitra}'),
        );
      },
      separatorBuilder: (context, i) => const Divider(
        height: 0,
      ),
      itemCount: mitra!.length,
    );
  }
}
