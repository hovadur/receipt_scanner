import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../app_module.dart';
import 'from_param_notifier.dart';

class FromParamScreen extends ConsumerWidget {
  const FromParamScreen({Key? key}) : super(key: key);
  static const String routeName = 'FromParamScreen';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final notifier = fromParamNotifier;
    return Scaffold(
        appBar: AppBar(title: Text(context.translate().fromParam)),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
            child: Column(children: [
              DateTimePicker(
                locale: Localizations.localeOf(context),
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: watch(notifier).dateTime.toString(),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now(),
                onChanged: (String value) =>
                    context.read(notifier).changeDateTime(value),
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: context.translate().totalAmount,
                    errorText: watch(notifier).totalError),
                onChanged: (String value) =>
                    context.read(notifier).changeTotal(value, context),
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration:
                    InputDecoration(labelText: context.translate().storage),
                onChanged: (String value) => context.read(notifier).fn = value,
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration:
                    InputDecoration(labelText: context.translate().document),
                onChanged: (String value) => context.read(notifier).fd = value,
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => apply(context, notifier),
                decoration: InputDecoration(
                    labelText: context.translate().documentAttribute),
                onChanged: (String value) => context.read(notifier).fpd = value,
              ),
              SizedBox(
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        autofocus: true,
                        onPressed: () => apply(context, notifier),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 4.0),
                        ),
                        child: Text(context.translate().apply),
                      ))),
            ])));
  }

  void apply(BuildContext context,
      ChangeNotifierProvider<FromParamNotifier> notifier) async {
    final receipt = context.read(notifier).apply();
    if (receipt == null) {
      context.showError(context.translate().invalidData);
    } else {
      AppNavigator.of(context).push(MaterialPage<Page>(
          name: ReceiptDetailsScreen.routeName,
          child: ReceiptDetailsScreen(receipt: receipt)));
    }
  }
}
