import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:main_app/features/load_setup/presentation/providers/setup_configuration_provider.dart';

class LoadSetupPage extends ConsumerWidget {
  const LoadSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeConfiguration = ref.watch(loadSetupConfigurationProvider);

    return Scaffold(
      body: Center(
        child: themeConfiguration.when(
          data: (_) => const CircularProgressIndicator(),
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Não foi possível carregar o tema.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(loadSetupConfigurationProvider),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
