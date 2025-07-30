import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/app_theme.dart';
import '../../common/app_strings.dart';
import '../../bloc/settings/settings_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../common/app_routes.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SettingsCubit>();
    final state = cubit.state;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing),
        child: ListView(
          children: [
            Text(AppStrings.settings, style: AppTheme.pageTitle),
            const SizedBox(height: AppTheme.spacing),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(AppStrings.profile),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.profile),
            ),
            const Divider(),
            DropdownButtonFormField<Locale>(
              value: state.locale,
              decoration: InputDecoration(labelText: AppStrings.language),
              items: const [
                DropdownMenuItem(value: Locale('de'), child: Text('Deutsch')),
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
              ],
              onChanged: (loc) {
                if (loc != null) {
                  context.read<SettingsCubit>().updateLocale(loc);
                }
              },
            ),
            const SizedBox(height: AppTheme.spacing),
            DropdownButtonFormField<ThemeMode>(
              value: state.themeMode,
              decoration: InputDecoration(labelText: AppStrings.theme),
              items: [
                DropdownMenuItem(
                    value: ThemeMode.system, child: Text(AppStrings.system)),
                DropdownMenuItem(
                    value: ThemeMode.light, child: Text(AppStrings.light)),
                DropdownMenuItem(
                    value: ThemeMode.dark, child: Text(AppStrings.dark)),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  context.read<SettingsCubit>().updateThemeMode(mode);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
