import 'dart:io';

import 'package:dokter_panggil/src/pages/components/input_form.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EresepWidget extends StatefulWidget {
  const EresepWidget({
    Key? key,
    required this.idKunjungan,
  }) : super(key: key);

  final int idKunjungan;

  @override
  State<EresepWidget> createState() => _EresepWidgetState();
}

class _EresepWidgetState extends State<EresepWidget> {
  final _formKey = GlobalKey<FormState>();
  final _namaApotek = TextEditingController();
  final _nomor = TextEditingController();

  void _kirimResep(String url) async {
    if (validateAndSave()) {
      String text = 'Hai $_namaApotek, E-RESEP\n${Uri.parse(url)}';
      String whatsappURlAndroid = "whatsapp://send?phone=$_nomor&text=$text";
      String whatappURLIos = "https://wa.me/$_nomor?text=$text";

      Uri toLaunchIos = Uri.parse(whatappURLIos);
      Uri toLaunchAndroid = Uri.parse(whatsappURlAndroid);
      if (Platform.isIOS) {
        if (await canLaunchUrl(toLaunchIos)) {
          await launchUrl(toLaunchIos);
        } else {
          _snakeBar('message');
        }
      } else {
        if (await canLaunchUrl(toLaunchAndroid)) {
          await launchUrl(toLaunchAndroid);
        } else {
          _snakeBar('Whatsapp is not installed');
        }
      }
    }
  }

  void _snakeBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  bool validateAndSave() {
    var formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 22.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'E-RESEP',
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Input(
              controller: _namaApotek,
              label: 'Nama',
              hint: 'Nama apotek tujuan',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              textCap: TextCapitalization.words,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 22.0,
            ),
            Input(
              controller: _nomor,
              label: 'Nomor',
              hint: 'Nomor telepon whatsapp apotek tujuan',
              maxLines: 1,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Input required';
                }
                return null;
              },
              keyType: TextInputType.number,
            ),
            const SizedBox(
              height: 32.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: ElevatedButton(
                onPressed: () => _kirimResep('testing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                ),
                child: const Text('Kirim Resep'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
