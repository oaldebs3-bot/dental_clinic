class ToothData {
  final int number;
  final String fdi;
  final String name;

  const ToothData({required this.number, required this.fdi, required this.name});

  static const List<ToothData> all = [
    // Upper right (quadrant 1)
    ToothData(number: 1, fdi: '11', name: 'قاطع مركزي علوي أيمن'),
    ToothData(number: 2, fdi: '12', name: 'قاطع جانبي علوي أيمن'),
    ToothData(number: 3, fdi: '13', name: 'ناب علوي أيمن'),
    ToothData(number: 4, fdi: '14', name: 'ضاحك أول علوي أيمن'),
    ToothData(number: 5, fdi: '15', name: 'ضاحك ثانٍ علوي أيمن'),
    ToothData(number: 6, fdi: '16', name: 'رحى أولى علوية يمنى'),
    ToothData(number: 7, fdi: '17', name: 'رحى ثانية علوية يمنى'),
    ToothData(number: 8, fdi: '18', name: 'رحى ثالثة علوية يمنى'),
    // Upper left (quadrant 2)
    ToothData(number: 9, fdi: '21', name: 'قاطع مركزي علوي أيسر'),
    ToothData(number: 10, fdi: '22', name: 'قاطع جانبي علوي أيسر'),
    ToothData(number: 11, fdi: '23', name: 'ناب علوي أيسر'),
    ToothData(number: 12, fdi: '24', name: 'ضاحك أول علوي أيسر'),
    ToothData(number: 13, fdi: '25', name: 'ضاحك ثانٍ علوي أيسر'),
    ToothData(number: 14, fdi: '26', name: 'رحى أولى علوية يسرى'),
    ToothData(number: 15, fdi: '27', name: 'رحى ثانية علوية يسرى'),
    ToothData(number: 16, fdi: '28', name: 'رحى ثالثة علوية يسرى'),
    // Lower left (quadrant 3)
    ToothData(number: 17, fdi: '31', name: 'قاطع مركزي سفلي أيسر'),
    ToothData(number: 18, fdi: '32', name: 'قاطع جانبي سفلي أيسر'),
    ToothData(number: 19, fdi: '33', name: 'ناب سفلي أيسر'),
    ToothData(number: 20, fdi: '34', name: 'ضاحك أول سفلي أيسر'),
    ToothData(number: 21, fdi: '35', name: 'ضاحك ثانٍ سفلي أيسر'),
    ToothData(number: 22, fdi: '36', name: 'رحى أولى سفلية يسرى'),
    ToothData(number: 23, fdi: '37', name: 'رحى ثانية سفلية يسرى'),
    ToothData(number: 24, fdi: '38', name: 'رحى ثالثة سفلية يسرى'),
    // Lower right (quadrant 4)
    ToothData(number: 25, fdi: '41', name: 'قاطع مركزي سفلي أيمن'),
    ToothData(number: 26, fdi: '42', name: 'قاطع جانبي سفلي أيمن'),
    ToothData(number: 27, fdi: '43', name: 'ناب سفلي أيمن'),
    ToothData(number: 28, fdi: '44', name: 'ضاحك أول سفلي أيمن'),
    ToothData(number: 29, fdi: '45', name: 'ضاحك ثانٍ سفلي أيمن'),
    ToothData(number: 30, fdi: '46', name: 'رحى أولى سفلية يمنى'),
    ToothData(number: 31, fdi: '47', name: 'رحى ثانية سفلية يمنى'),
    ToothData(number: 32, fdi: '48', name: 'رحى ثالثة سفلية يمنى'),
  ];

  static ToothData forNumber(int number) => all.firstWhere((t) => t.number == number);
}
