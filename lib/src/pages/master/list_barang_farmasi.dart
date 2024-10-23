import 'package:dokter_panggil/src/blocs/master_farmasi_paginate_bloc.dart';
import 'package:dokter_panggil/src/models/master_farmasi_paginate_model.dart';
import 'package:flutter/material.dart';

class ListBarangFarmasi extends StatefulWidget {
  const ListBarangFarmasi({
    Key? key,
    this.data,
    this.bloc,
  }) : super(key: key);

  final MasterFarmasiPaginateModel? data;
  final MasterFarmasiPaginateBloc? bloc;

  @override
  State<ListBarangFarmasi> createState() => _ListBarangFarmasiState();
}

class _ListBarangFarmasiState extends State<ListBarangFarmasi> {
  final ScrollController _scrollController = ScrollController();
  List<BarangFarmasi>? _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data!.barangFarmasi;
    _scrollController.addListener(_scrollListen);
  }

  void _scrollListen() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.bloc!.getMasterFarmasiNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, i) {
        if (i == _data!.length) {
          return const SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  width: 12,
                ),
                Text('Memuat...'),
              ],
            ),
          );
        }
        var farmasi = _data![i];
        return ListTile(
          onTap: () => Navigator.pop(context, farmasi),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
          dense: true,
          title: farmasi.mitraFarmasi == null
              ? Text('${farmasi.namaBarang}')
              : Text(
                  '${farmasi.namaBarang} - ${farmasi.mitraFarmasi!.namaMitra}',
                ),
        );
      },
      separatorBuilder: (context, i) => const Divider(
        height: 0,
      ),
      itemCount: widget.data!.totalPage != widget.data!.currentPage
          ? _data!.length + 1
          : _data!.length,
    );
  }
}
