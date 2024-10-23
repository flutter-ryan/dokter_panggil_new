class TindakanPaketSelected {
  TindakanPaketSelected({
    this.id,
    this.namaTindakan,
    this.jumlah = 1,
    this.tarif = 0,
    this.total = 0,
    this.isDokter = true,
  });
  int? id;
  String? namaTindakan;
  int jumlah;
  int tarif;
  int total;
  bool isDokter;
}
