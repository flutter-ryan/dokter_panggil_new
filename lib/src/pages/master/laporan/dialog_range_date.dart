import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dokter_panggil/src/source/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DialogRangeDate extends StatefulWidget {
  const DialogRangeDate({
    super.key,
    this.selected,
  });

  final List<DateTime?>? selected;

  @override
  State<DialogRangeDate> createState() => _DialogRangeDateState();
}

class _DialogRangeDateState extends State<DialogRangeDate> {
  List<DateTime?> _dates = [
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
  ];
  String _selectedConvert = 'pdf';

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) {
      _dates = widget.selected!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 12),
              child: Text(
                'Pilih tanggal laporan',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(
              height: 0.0,
              color: Colors.grey,
            ),
            CalendarDatePicker2(
              config: CalendarDatePicker2WithActionButtonsConfig(
                centerAlignModePicker: true,
                calendarType: CalendarDatePicker2Type.range,
                selectedDayHighlightColor: kPrimaryColor,
              ),
              value: _dates,
              onValueChanged: (dates) => _dates = dates,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 18.0),
              child: Text(
                'Convert To : ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () => setState(() => _selectedConvert = 'pdf'),
                      child: Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color: _selectedConvert == 'pdf'
                              ? kPrimaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: SvgPicture.asset(
                          'images/pdf.svg',
                          height: 62,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () => setState(() => _selectedConvert = 'excel'),
                      child: Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color: _selectedConvert == 'excel'
                              ? kPrimaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: SvgPicture.asset(
                          'images/excel.svg',
                          height: 62,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Divider(
              height: 0.0,
              color: Colors.grey,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        minimumSize: const Size(72, 42)),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(
                        context,
                        SelectedDateLaporanHarian(
                          tanggal: _dates,
                          convert: _selectedConvert,
                        )),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(100, 42)),
                    child: const Text('Pilih'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedDateLaporanHarian {
  SelectedDateLaporanHarian({
    this.tanggal,
    this.convert,
  });
  List<DateTime?>? tanggal;
  String? convert;
}
