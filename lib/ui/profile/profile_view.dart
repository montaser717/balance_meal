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
                      const Text("Körperdaten", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          icon: Icon(Icons.person),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Name erforderlich' : null,
                      ),
                      TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Alter',
                          icon: Icon(Icons.cake),
                        ),
                        validator: (value) {
                          final age = int.tryParse(value ?? '');
                          if (age == null || age < 10 || age > 120) {
                            return 'Alter muss zwischen 10–120 sein';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: heightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Größe (m)',
                          icon: Icon(Icons.height),
                        ),
                        validator: (value) {
                          final height = double.tryParse(value ?? '');
                          if (height == null || height < 1.0 || height > 2.5) {
                            return 'Größe muss zwischen 1.00 und 2.50 sein';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Gewicht (kg)',
                          icon: Icon(Icons.fitness_center),
                        ),
                        validator: (value) {
                          final weight = double.tryParse(value ?? '');
                          if (weight == null || weight <= 0) {
                            return 'Gewicht muss sinnvoll sein';
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
                      const Text("Lebensstil", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                        onChanged: (val) => setState(() => selectedGender = val!),
                        decoration: const InputDecoration(
                          labelText: 'Geschlecht',
                          icon: Icon(Icons.transgender),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedActivity,
                        items: activities.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                        onChanged: (val) => setState(() => selectedActivity = val!),
                        decoration: const InputDecoration(
                          labelText: 'Aktivität',
                          icon: Icon(Icons.directions_run),
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedGoal,
                        items: goals.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                        onChanged: (val) => setState(() => selectedGoal = val!),
                        decoration: const InputDecoration(
                          labelText: 'Ziel',
                          icon: Icon(Icons.flag),
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
                        const SnackBar(content: Text('Profil gespeichert')),
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
