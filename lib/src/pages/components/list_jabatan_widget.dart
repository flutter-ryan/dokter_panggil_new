import 'package:admin_dokter_panggil/src/models/master_jabatan_model.dart';
import 'package:flutter/material.dart';

class ListJabatanWidget extends StatefulWidget {
  const ListJabatanWidget({
    super.key,
    required this.data,
    this.selectedId = 0,
    required this.selectId,
  });

  final List<Jabatan> data;
  final int selectedId;
  final Function(Jabatan? jabatan) selectId;

  @override
  State<ListJabatanWidget> createState() => _ListJabatanWidgetState();
}

class _ListJabatanWidgetState extends State<ListJabatanWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (context, i) => const Divider(
        height: 0,
      ),
      itemBuilder: (context, i) {
        var jabatan = widget.data[i];
        return ListTile(
          onTap: () => widget.selectId(jabatan),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
          title: Text('${jabatan.namaJabatan}'),
          trailing: widget.selectedId == jabatan.id
              ? const Icon(
                  Icons.check_box,
                  color: Colors.green,
                )
              : null,
        );
      },
      itemCount: widget.data.length,
    );
  }
}
