import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DismissibleCard extends StatelessWidget {
  DismissibleCard(
      {Key? key,
      required this.id,
      required this.confirmDismiss,
      required this.onDismissed,
      required this.child})
      : super(key: key);

  final String id;
  final Future<bool> Function() confirmDismiss;
  final VoidCallback onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: Key(id),
        actionPane: const SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: <Widget>[
          IconSlideAction(
            caption: 'deleteEllipsis'.tr(),
            color: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              if (await confirmDismiss()) {
                onDismissed();
              }
            },
          )
        ],
        dismissal: SlidableDismissal(
            onDismissed: (_) => onDismissed(),
            onWillDismiss: (actionType) async {
              final result = await showDialog<bool>(
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
              return result == true ? await confirmDismiss() : false;
            },
            child: const SlidableDrawerDismissal()),
        child: Card(child: child));
  }
}
