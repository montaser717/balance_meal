import 'package:balance_meal/bloc/settings/settings_cubit.dart';
import 'package:balance_meal/ui/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  testWidgets('SettingsView shows dropdowns', (tester) async {
    final box = MockBox();
    when(() => box.get('themeMode', defaultValue: any(named: 'defaultValue')))
        .thenReturn(ThemeMode.system.index);
    when(() => box.get('locale', defaultValue: any(named: 'defaultValue')))
        .thenReturn('de');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: BlocProvider(
          create: (_) => SettingsCubit(box),
          child: const SettingsView(),
        )),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Deutsch'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
  });
}
