import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DismissibleCard extends StatelessWidget {
  DismissibleCard({this.id, this.confirmDismiss, this.onDismissed, this.child});

  final String id;
  final ConfirmDismissCallback confirmDismiss;
  final DismissDirectionCallback onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(id),
        dragStartBehavior: DragStartBehavior.down,
        direction: DismissDirection.startToEnd,
        background: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(Icons.delete, color: Colors.white),
                  Text(AppLocalizations.of(context).deleteEllipsis,
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            )),
        confirmDismiss: (DismissDirection direction) async {
          if (await confirmDismiss(direction)) {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context).deleteConfirmation),
                  content: Text(AppLocalizations.of(context).sureDelete),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(AppLocalizations.of(context).delete)),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(AppLocalizations.of(context).cancel),
                    ),
                  ],
                );
              },
            );
          } else {
            return false;
          }
        },
        onDismissed: onDismissed,
        child: Card(child: child));
  }
}
