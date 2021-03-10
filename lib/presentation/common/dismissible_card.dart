import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DismissibleCard extends StatelessWidget {
  DismissibleCard(
      {required this.id,
      required this.confirmDismiss,
      required this.onDismissed,
      required this.child});

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
                  Text('deleteEllipsis'.tr(),
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            )),
        confirmDismiss: (DismissDirection direction) async {
          if (await confirmDismiss(direction) == true) {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('deleteConfirmation').tr(),
                  content: const Text('sureDelete').tr(),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('delete').tr()),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('cancel').tr(),
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
