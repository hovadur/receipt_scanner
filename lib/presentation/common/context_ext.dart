import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

extension GoogleSignIn on BuildContext {
  AppLocalizations translate() {
    return AppLocalizations.of(this)!;
  }

  void showError(String message) {
    showDialog(
        context: this,
        builder: (dialogContext) => AlertDialog(
              title: Text(translate().warning),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(translate().close))
              ],
            ));
  }

  Map<IconData, String> category() {
    return {
      Icons.local_dining: translate().food,
      Icons.house: translate().home,
      Icons.commute: translate().transport,
      Icons.sports_esports: translate().entertainment,
      Icons.shopping_bag: translate().clothes,
      Icons.local_phone: translate().connection,
      Icons.medical_services: translate().health,
      Icons.beach_access: translate().cosmetics,
    };
  }
}
