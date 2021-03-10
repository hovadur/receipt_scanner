import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension GoogleSignIn on BuildContext {
  void showError(String message) {
    showDialog(
        context: this,
        builder: (dialogContext) => AlertDialog(
              title: const Text('warning').tr(),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('close').tr())
              ],
            ));
  }

  Map<IconData, String> category() {
    return {
      Icons.local_dining: 'food'.tr(),
      Icons.house: 'home'.tr(),
      Icons.commute: 'transport'.tr(),
      Icons.sports_esports: 'entertainment'.tr(),
      Icons.shopping_bag: 'clothes'.tr(),
      Icons.local_phone: 'connection'.tr(),
      Icons.medical_services: 'health'.tr(),
      Icons.beach_access: 'cosmetics'.tr(),
    };
  }
}
