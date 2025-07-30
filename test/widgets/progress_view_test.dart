import 'package:balance_meal/models/weight_entry.dart';
import 'package:balance_meal/ui/progress/progress_view.dart';
import 'package:balance_meal/common/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/hive_test_helper.dart';
import 'package:hive/hive.dart';

void main() {
  setUpAll(() async {
    await setUpHive();
  });

  tearDownAll(() async {
    await tearDownHive();
  });

  testWidgets('displays weight entries', (tester) async {
    final box = Hive.box<WeightEntry>('weightBox');
    await box.add(WeightEntry(date: DateTime.now(), weight: 80));
    await tester.pumpWidget(const MaterialApp(home: ProgressView()));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.noWeights), findsNothing);
    expect(find.text('Gewicht'), findsOneWidget);
  });
}
