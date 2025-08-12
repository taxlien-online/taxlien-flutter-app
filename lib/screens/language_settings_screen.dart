import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/localization_service.dart';

class LanguageSettingsScreen extends StatelessWidget {
  final LocalizationService localizationService;

  const LanguageSettingsScreen({
    super.key,
    required this.localizationService,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListenableBuilder(
        listenable: localizationService,
        builder: (context, child) {
          final currentLanguage = localizationService.getCurrentLanguageCode();
          final availableLanguages = localizationService.getAvailableLanguages();
          
          return ListView.builder(
            itemCount: availableLanguages.length,
            itemBuilder: (context, index) {
              final language = availableLanguages[index];
              final isSelected = language['code'] == currentLanguage ||
                  (language['code'] == 'system' && localizationService.isSystemLanguage);
              
              return ListTile(
                title: Text(
                  language['name']!,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  await localizationService.setLanguage(language['code']!);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${l10n.languageChanged} to ${language['name']}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
} 