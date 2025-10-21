import 'package:admin_dokter_panggil/src/blocs/master_kategori_tindakan_bloc.dart';
import 'package:admin_dokter_panggil/src/models/master_kategori_tindakan_model.dart';
import 'package:admin_dokter_panggil/src/pages/components/error_response.dart';
import 'package:admin_dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:admin_dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:admin_dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';

class ListKategoriTindakanPage extends StatefulWidget {
  const ListKategoriTindakanPage({super.key});

  @override
  State<ListKategoriTindakanPage> createState() =>
      _ListKategoriTindakanPageState();
}

class _ListKategoriTindakanPageState extends State<ListKategoriTindakanPage> {
  final _masterKategoriTindakanBloc = MasterKategoriTindakanBloc();

  @override
  void initState() {
    super.initState();
    _masterKategoriTindakanBloc.getKategoriTindakan();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<MasterKategoriTindakanModel>>(
      stream: _masterKategoriTindakanBloc.kategoriTindakanStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data!.status) {
            case Status.loading:
              return SizedBox(
                height: 200,
                child: LoadingKit(
                  color: kPrimaryColor,
                ),
              );
            case Status.error:
              return Padding(
                padding: const EdgeInsets.all(22.0),
                child: ErrorResponse(
                  message: snapshot.data!.message,
                  onTap: () {
                    _masterKategoriTindakanBloc.getKategoriTindakan();
                    setState(() {});
                  },
                ),
              );
            case Status.completed:
              return SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Pilih salah satu',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ...snapshot.data!.data!.data!.map(
                      (kategori) => ListTile(
                        onTap: () => Navigator.pop(context, kategori),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                        title: Text('${kategori.namaKategori}'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(18),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          minimumSize: Size(double.infinity, 42),
                        ),
                        child: Text('Tambah Master Kategori Tindakan'),
                      ),
                    ),
                  ],
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
