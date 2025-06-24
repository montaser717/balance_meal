import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/profile/profile_cubit.dart';
import '../../blocs/profile/profile_state.dart';
import '../../models/user_profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => previous.isSaving && !current.isSaving,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil gespeichert ✅")),
        );
        context.go('/diary');
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final profile = state.profile;

          return Scaffold(
            appBar: AppBar(title: const Text('Profil')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Körperdaten", style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: profile.name,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person),
                              ),
                              validator: (value) =>
                              (value == null || value.trim().isEmpty) ? 'Name erforderlich' : null,
                              onChanged: (value) =>
                                  context.read<ProfileCubit>().updateName(value),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: profile.age.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Alter',
                                prefixIcon: Icon(Icons.cake),
                                helperText: 'Bitte gib dein Alter in Jahren an',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final age = int.tryParse(value ?? '');
                                if (age == null || age < 10 || age > 120) {
                                  return 'Alter muss zwischen 10–120 sein';
                                }
                                return null;
                              },
                              onChanged: (value) => context
                                  .read<ProfileCubit>()
                                  .updateAge(int.tryParse(value) ?? 0),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: profile.height.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Größe (m)',
                                hintText: 'z. B. 1.80',
                                prefixIcon: Icon(Icons.height),
                                helperText: 'Angabe in Metern, z. B. 1.80',
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: (value) {
                                final height = double.tryParse(value?.replaceAll(',', '.') ?? '');
                                if (height == null || height < 1.0 || height > 2.5) {
                                  return 'Größe muss zwischen 1.00 und 2.50 sein';
                                }
                                return null;
                              },
                              onChanged: (value) => context.read<ProfileCubit>().updateHeight(
                                double.tryParse(value.replaceAll(',', '.')) ?? 0,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              initialValue: profile.weight.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Gewicht (kg)',
                                prefixIcon: Icon(Icons.fitness_center),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final weight = double.tryParse(value ?? '');
                                if (weight == null || weight < 20 || weight > 300) {
                                  return 'Gewicht muss sinnvoll sein';
                                }
                                return null;
                              },
                              onChanged: (value) => context
                                  .read<ProfileCubit>()
                                  .updateWeight(double.tryParse(value) ?? 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lebensstil", style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<Gender>(
                              value: profile.gender,
                              items: Gender.values
                                  .map((g) => DropdownMenuItem(value: g, child: Text(g.name)))
                                  .toList(),
                              onChanged: context.read<ProfileCubit>().updateGender,
                              decoration: const InputDecoration(
                                labelText: 'Geschlecht',
                                prefixIcon: Icon(Icons.transgender),
                              ),
                              validator: (value) => value == null ? 'Bitte Geschlecht wählen' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<ActivityLevel>(
                              value: profile.activityLevel,
                              items: ActivityLevel.values
                                  .map((level) => DropdownMenuItem(
                                value: level,
                                child: Text(level.name),
                              ))
                                  .toList(),
                              onChanged: context.read<ProfileCubit>().updateActivityLevel,
                              decoration: const InputDecoration(
                                labelText: 'Aktivität',
                                prefixIcon: Icon(Icons.directions_run),
                              ),
                              validator: (value) => value == null ? 'Bitte Aktivitätslevel wählen' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<Goal>(
                              value: profile.goal,
                              items: Goal.values
                                  .map((goal) => DropdownMenuItem(
                                value: goal,
                                child: Text(goal.name),
                              ))
                                  .toList(),
                              onChanged: context.read<ProfileCubit>().updateGoal,
                              decoration: const InputDecoration(
                                labelText: 'Ziel',
                                prefixIcon: Icon(Icons.flag),
                              ),
                              validator: (value) => value == null ? 'Bitte Ziel wählen' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    state.isSaving
                        ? const Center(child: CircularProgressIndicator())
                        : FilledButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ProfileCubit>().saveProfile();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Bitte alle Pflichtfelder korrekt ausfüllen")),
                          );
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text("Speichern"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
