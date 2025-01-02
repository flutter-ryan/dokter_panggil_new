import 'dart:convert';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:dokter_panggil/src/blocs/dokumen_lab_save_bloc.dart';
import 'package:dokter_panggil/src/models/dokumen_lab_save_model.dart';
import 'package:dokter_panggil/src/pages/components/error_dialog.dart';
import 'package:dokter_panggil/src/pages/components/loading_kit.dart';
import 'package:dokter_panggil/src/pages/components/success_dialog.dart';
import 'package:dokter_panggil/src/repositories/responseApi/api_response.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:dokter_panggil/src/source/size_config.dart';
import 'package:dokter_panggil/src/source/transition/animated_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_previewer/file_previewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_to_pdf_converter/image_to_pdf_converter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FormDokumenLab extends StatefulWidget {
  const FormDokumenLab({
    super.key,
    this.idKunjungan,
  });

  final int? idKunjungan;

  @override
  State<FormDokumenLab> createState() => _FormDokumenLabState();
}

class _FormDokumenLabState extends State<FormDokumenLab> {
  final _dokumenLabSaveBloc = DokumenLabSaveBloc();
  List<String> _pictures = [];
  String? _image64, _extension;
  Widget? _imagePreview;

  void _selectMedia() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => _mediaSelectionWidget(context),
    ).then((value) {
      if (value != null) {
        var data = value as String;
        if (data == 'camera') {
          _showScanner();
        } else {
          _showFolder();
        }
      }
    });
  }

  void _showScanner() async {
    try {
      var pictures = await CunningDocumentScanner.getPictures() ?? [];
      Directory tempDir = await getTemporaryDirectory();
      List<String> path = [];
      for (final picture in pictures) {
        var result = await FlutterImageCompress.compressAndGetFile(
          picture,
          '${tempDir.path}/${p.basename(picture)}',
          quality: 50,
        );
        path.add(result!.path);
      }

      setState(() {
        _pictures = path;
        _imagePreview = null;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<void> _showFolder() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result == null) return;
    Widget thumbnail;
    if (result.files.single.extension != 'pdf') {
      thumbnail = await FilePreview.getThumbnail(
        result.files.single.path!,
      );
    } else {
      thumbnail = Column(
        children: [
          Expanded(
            child: PDFView(
              filePath: result.files.single.path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: _selectMedia,
              style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
              child: const Text('Pilih media baru'),
            ),
          )
        ],
      );
    }
    Directory tempDir = await getTemporaryDirectory();
    var image = await FlutterImageCompress.compressAndGetFile(
      result.files.single.path!,
      '${tempDir.path}/${p.basename(result.files.single.path!)}.${p.basename(result.files.single.path!)}',
      quality: 50,
    );
    List<int> bytes = File(image!.path).readAsBytesSync();
    setState(() {
      _image64 = base64Encode(bytes);
      _extension = result.files.single.extension;
      _imagePreview = thumbnail;
      _pictures.clear();
    });
  }

  void _simpan() async {
    List<File> sendImages = [];
    String? doc, ext;
    if (_pictures.isNotEmpty) {
      for (final picture in _pictures) {
        sendImages.add(File(picture));
      }
      await ImageToPdf.imageList(listOfFiles: sendImages).then((value) {
        var pdfBytes = File(value.path).readAsBytesSync();
        doc = base64Encode(pdfBytes);
        ext = p.extension(value.path);
      });
      if (!mounted) return;
    } else {
      doc = _image64;
      ext = '.$_extension';
    }
    _dokumenLabSaveBloc.idKunjunganSink.add(widget.idKunjungan!);
    _dokumenLabSaveBloc.imageSink.add(doc!);
    _dokumenLabSaveBloc.extSink.add(ext!);
    _dokumenLabSaveBloc.simpanDokumenLab();
    _showStreamSimpanDokumenLab();
  }

  void _showStreamSimpanDokumenLab() {
    showAnimatedDialog(
      context: context,
      builder: (context) {
        return _buildStreamSimpanDokumenLab(context);
      },
      duration: const Duration(milliseconds: 500),
      animationType: DialogTransitionType.slideFromBottomFade,
    ).then((value) {
      if (value != null) {
        var data = value as DokumenLab;
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Navigator.pop(context, data);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      bottom: false,
      child: Container(
        height: SizeConfig.blockSizeVertical * 60,
        color: Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _selectMedia,
                        child: _pictures.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_search_rounded,
                                    size: 42,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Tap untuk memilih media gambar',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              )
                            : _imagePreview ??
                                Center(
                                  child: GridView(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 18,
                                      crossAxisSpacing: 18,
                                    ),
                                    children: _pictures
                                        .map(
                                          (picture) => Image.file(
                                            File(picture),
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                child: Text('Upload Dokumen'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _mediaSelectionWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Pilih media',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.grey[100],
                foregroundColor: Colors.grey,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'camera'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          leading: SvgPicture.asset('images/camera.svg'),
          title: const Text(
            'Camera',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const Divider(
          height: 0,
        ),
        ListTile(
          onTap: () => Navigator.pop(context, 'folder'),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          leading: SvgPicture.asset('images/folder.svg'),
          title: const Text(
            'File/Folder',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 22,
        )
      ],
    );
  }

  Widget _buildStreamSimpanDokumenLab(BuildContext context) {
    return StreamBuilder<ApiResponse<DokumenLabSaveModel>>(
        stream: _dokumenLabSaveBloc.dokumenLabStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data!.status) {
              case Status.loading:
                return const LoadingKit();
              case Status.error:
                return ErrorDialog(
                  message: snapshot.data!.message,
                  onTap: () => Navigator.pop(context),
                );
              case Status.completed:
                return SuccessDialog(
                  message: snapshot.data!.data!.message,
                  onTap: () =>
                      Navigator.pop(context, snapshot.data!.data!.data),
                );
            }
          }
          return const SizedBox();
        });
  }
}
