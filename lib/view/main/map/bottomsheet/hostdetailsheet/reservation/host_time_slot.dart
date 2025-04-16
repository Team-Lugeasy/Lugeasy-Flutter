enum TimeSlot {
  t0001("00:00 - 01:00", true),
  t0102("01:00 - 02:00", true),
  t0203("02:00 - 03:00", true),
  t0304("03:00 - 04:00", true),
  t0405("04:00 - 05:00", true),
  t0506("05:00 - 06:00", true),
  t0607("06:00 - 07:00", true),
  t0708("07:00 - 08:00", true),
  t0809("08:00 - 09:00", true),
  t0910("09:00 - 10:00", true),
  t1011("10:00 - 11:00", true),
  t1112("11:00 - 12:00", true),
  t1213("12:00 - 01:00", false),
  t1314("01:00 - 02:00", false),
  t1415("02:00 - 03:00", false),
  t1516("03:00 - 04:00", false),
  t1617("04:00 - 05:00", false),
  t1718("05:00 - 06:00", false),
  t1819("06:00 - 07:00", false),
  t1920("07:00 - 08:00", false),
  t2021("08:00 - 09:00", false),
  t2122("09:00 - 10:00", false),
  t2223("10:00 - 11:00", false),
  t2324("11:00 - 12:00", false);

  final String label;
  final bool isAm;

  const TimeSlot(this.label, this.isAm);
}

extension TimeSlotGroup on List<TimeSlot> {
  List<TimeSlot> get amSlots => where((t) => t.isAm).toList();
  List<TimeSlot> get pmSlots => where((t) => !t.isAm).toList();
}
