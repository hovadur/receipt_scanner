import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../presentation/common/context_ext.dart';

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
                  Text(context.translate().deleteEllipsis,
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
                  title: Text(context.translate().deleteConfirmation),
                  content: Text(context.translate().sureDelete),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(context.translate().delete)),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(context.translate().cancel),
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
