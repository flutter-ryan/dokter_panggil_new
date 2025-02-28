import 'package:dokter_panggil/src/models/master_jabatan_model.dart';
import 'package:dokter_panggil/src/pages/components/button_edit_master.dart';
import 'package:dokter_panggil/src/pages/components/close_button.dart';
import 'package:dokter_panggil/src/pages/components/header.dart';
import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/pages/components/search_input_form.dart';
import 'package:dokter_panggil/src/pages/master/profesi_pencarian_page.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/transition/slide_left_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JabatanPage extends StatefulWidget {
  const JabatanPage({super.key});

  @override
  State<JabatanPage> createState() => _JabatanPageState();
}

class _JabatanPageState extends State<JabatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _group = TextEditingController();
  final _jabatan = TextEditingController();
  final bool _editForm = false;

  bool validateAndSave() {
    var formData = _formKey.currentState;
    if (formData!.validate()) {
      return true;
    }
    return false;
  }

  void _simpan() {
    //
  }

  void _edit(int? id, String? jabatan) {
    //
  }

  void _update() {
    //
  }

  void _delete() {
    //
  }

  void _batal() {
    //
  }

  @override
  void dispose() {
    _group.dispose();
    _jabatan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: 'Tambah Profesi',
                subtitle: SearchInputForm(
                  isReadOnly: true,
                  hint: 'Pencarian profesi',
                  onTap: () => Navigator.push(
                    context,
                    SlideLeftRoute(
                      page: const ProfesiPencarianPage(),
                    ),
                  ).then((value) {
                    if (value != null) {
                      if (!mounted) return;
                      FocusScope.of(context).requestFocus(FocusNode());
                      var data = value as Jabatan;
                      _edit(data.id, data.namaJabatan);
                    }
                  }),
                ),
                closeButton: const ClosedButton(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(32.0),
                  children: [
                    Input(
                      controller: _jabatan,
                      label: 'Profesi',
                      hint: 'Nama profesi',
                      maxLines: 1,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Input required';
                        }
                        return null;
                      },
                      onSave: (val) {},
                      textCap: TextCapitalization.words,
                    ),
                    const SizedBox(
                      height: 52.0,
                    ),
                    if (_editForm)
                      ButtonEditMaster(
                        update: _update,
                        delete: _delete,
                        batal: _batal,
                      )
                    else
                      SizedBox(
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: _simpan,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            backgroundColor: kPrimaryColor,
                          ),
                          child: const Text('SIMPAN'),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
