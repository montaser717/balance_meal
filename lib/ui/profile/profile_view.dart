import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:balance_meal/common/app_strings.dart';
import 'package:balance_meal/common/app_theme.dart';
import 'package:balance_meal/common/app_routes.dart';
import 'package:balance_meal/bloc/profile/profile_cubit.dart';
import 'package:balance_meal/models/user_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();

    cubit.loadProfile().then((_) {
      final state = cubit.state;
      if (state.errorMessage == null) {
        final profile = state.profile;
        setState(() {
          nameController.text = profile.name;
          ageController.text = profile.age.toString();
          heightController.text = profile.height.toString();
          weightController.text = profile.weight.toString();
          selectedGender = profile.gender;
          selectedActivity = profile.activityLevel;
          selectedGoal = profile.goal;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
      }
    });
  }

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  String selectedGender = 'maennlich';
  String selectedActivity = 'mittel';
  String selectedGoal = 'halten';

  final genders = ['maennlich', 'weiblich', 'divers'];
  final activities = ['gering', 'mittel', 'hoch'];
  final goals = ['abnehmen', 'zunehmen', 'halten'];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacing),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: AppTheme.spacing * 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.details, style: textTheme.titleMedium),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: AppStrings.name,
                          icon: const Icon(Icons.person),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? '${AppStrings.name} ${AppStrings.requiredField}' : null,
                      ),
                      TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: AppStrings.age,
                          icon: const Icon(Icons.cake),
                        ),
                        validator: (value) {
                          final age = int.tryParse(value ?? '');
                          if (age == null || age < 10 || age > 120) {
                            return '${AppStrings.age} muss zwischen 10–120 sein';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: heightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: AppStrings.hight,
                          icon: const Icon(Icons.height),
                        ),
                        validator: (value) {
                          final height = double.tryParse(value ?? '');
                          if (height == null || height < 1.0 || height > 2.5) {
                            return '${AppStrings.hight} muss zwischen 1.00 und 2.50 sein';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: AppStrings.weight,
                          icon: const Icon(Icons.fitness_center),
                        ),
                        validator: (value) {
                          final weight = double.tryParse(value ?? '');
                          if (weight == null || weight <= 0) {
                            return '${AppStrings.weight} muss sinnvoll sein';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.lifestyle, style: textTheme.titleMedium),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        items: genders.map((g) {
                          final display = {
                            'maennlich': AppStrings.male,
                            'weiblich': AppStrings.female,
                            'divers': 'divers',
                          }[g] ?? g;
                          return DropdownMenuItem(value: g, child: Text(display));
                        }).toList(),
                        onChanged: (val) => setState(() => selectedGender = val!),
                        decoration: InputDecoration(
                          labelText: AppStrings.Sex,
                          icon: const Icon(Icons.transgender),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedActivity,
                        items: activities.map((a) {
                          final display = {
                            'gering': AppStrings.low,
                            'mittel': AppStrings.middel,
                            'hoch': AppStrings.high,
                          }[a] ?? a;
                          return DropdownMenuItem(value: a, child: Text(display));
                        }).toList(),
                        onChanged: (val) => setState(() => selectedActivity = val!),
                        decoration: const InputDecoration(
                          labelText: 'Aktivität', // Optional: in AppStrings ergänzen
                          icon: Icon(Icons.directions_run),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedGoal,
                        items: goals.map((g) {
                          final display = {
                            'abnehmen': AppStrings.loseWeight,
                            'zunehmen': AppStrings.gainWeight,
                            'halten': AppStrings.holdWeight,
                          }[g] ?? g;
                          return DropdownMenuItem(value: g, child: Text(display));
                        }).toList(),
                        onChanged: (val) => setState(() => selectedGoal = val!),
                        decoration: InputDecoration(
                          labelText: AppStrings.goal,
                          icon: const Icon(Icons.flag),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacing * 1.5),

              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedProfile = UserProfile(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      height: double.parse(heightController.text),
                      weight: double.parse(weightController.text),
                      gender: selectedGender,
                      activityLevel: selectedActivity,
                      goal: selectedGoal,
                    );

                    context.read<ProfileCubit>().saveProfile(updatedProfile);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${AppStrings.profile} ${AppStrings.save}')),
                    );

                    if (Navigator.of(context).canPop()) {
                      context.pop(true);
                    } else {
                      context.go(AppRoutes.diary);
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(AppStrings.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
