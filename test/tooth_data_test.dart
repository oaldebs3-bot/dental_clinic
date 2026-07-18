import 'package:flutter_test/flutter_test.dart';
import 'package:dental_clinic/widgets/tooth_data.dart';

void main() {
  test('ToothData has 32 teeth', () {
    expect(ToothData.all.length, 32);
  });

  test('FDI notation is correct for tooth 1', () {
    final t = ToothData.forNumber(1);
    expect(t.fdi, '11');
    expect(t.name, 'قاطع مركزي علوي أيمن');
  });

  test('FDI notation is correct for tooth 16', () {
    final t = ToothData.forNumber(16);
    expect(t.fdi, '28');
    expect(t.name, 'رحى ثالثة علوية يسرى');
  });

  test('FDI notation is correct for tooth 32', () {
    final t = ToothData.forNumber(32);
    expect(t.fdi, '48');
    expect(t.name, 'رحى ثالثة سفلية يمنى');
  });

  test('FDI quadrant 1 for teeth 1-8', () {
    for (int i = 1; i <= 8; i++) {
      expect(ToothData.forNumber(i).fdi.startsWith('1'), true);
    }
  });

  test('FDI quadrant 2 for teeth 9-16', () {
    for (int i = 9; i <= 16; i++) {
      expect(ToothData.forNumber(i).fdi.startsWith('2'), true);
    }
  });

  test('FDI quadrant 3 for teeth 17-24', () {
    for (int i = 17; i <= 24; i++) {
      expect(ToothData.forNumber(i).fdi.startsWith('3'), true);
    }
  });

  test('FDI quadrant 4 for teeth 25-32', () {
    for (int i = 25; i <= 32; i++) {
      expect(ToothData.forNumber(i).fdi.startsWith('4'), true);
    }
  });
}
