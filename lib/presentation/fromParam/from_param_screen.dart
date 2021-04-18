import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/context_ext.dart';
import '../../presentation/details/receipt_details_screen.dart';
import 'from_param_notifier.dart';

class FromParamScreen extends ConsumerWidget {
  const FromParamScreen({Key? key}) : super(key: key);
  static const String routeName = 'FromParamScreen';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final notifier = fromParamNotifier;
    return Scaffold(
        appBar: AppBar(title: const Text('fromParam').tr()),
        body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
            child: Column(children: [
              DateTimePicker(
                locale: context.locale,
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: watch(notifier).dateTime.toString(),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now(),
                onChanged: (String value) =>
                    context.read(notifier).changeDateTime(value),
              ),
              _TextFields(),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => apply(context, notifier),
                decoration:
                    InputDecoration(labelText: 'documentAttribute'.tr()),
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
                        child: const Text('apply').tr(),
                      ))),
            ])));
  }

  void apply(BuildContext context,
      ChangeNotifierProvider<FromParamNotifier> notifier) async {
    final receipt = context.read(notifier).apply();
    if (receipt == null) {
      context.showError('invalidData'.tr());
    } else {
      AppNavigator.of(context).push(MaterialPage<Page>(
          name: ReceiptDetailsScreen.routeName,
          child: ReceiptDetailsScreen(receipt: receipt)));
    }
  }
}

class _TextFields extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final notifier = fromParamNotifier;
    return Column(children: [
      const SizedBox(height: 8),
      TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: 'totalAmount'.tr(),
            errorText: watch(notifier).totalError),
        onChanged: (String value) =>
            context.read(notifier).changeTotal(value, context),
      ),
      const SizedBox(height: 8),
      TextField(
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'storage'.tr()),
        onChanged: (String value) => context.read(notifier).fn = value,
      ),
      const SizedBox(height: 8),
      TextField(
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'document'.tr()),
        onChanged: (String value) => context.read(notifier).fd = value,
      ),
    ]);
  }
}
