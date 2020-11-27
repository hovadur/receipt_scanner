import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/presentation/budgets/budgets_notifier.dart';
import 'package:ctr/presentation/budgets/budgets_ui.dart';
import 'package:ctr/presentation/camera/camera_notifier.dart';
import 'package:ctr/presentation/details/receipt_details_notifier.dart';
import 'package:ctr/presentation/details/receipt_details_param.dart';
import 'package:ctr/presentation/drawer/drawer_dropdown_notifier.dart';
import 'package:ctr/presentation/drawer/drawer_notifier.dart';
import 'package:ctr/presentation/fromFile/from_file_notifier.dart';
import 'package:ctr/presentation/myreceipts/my_item_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipt_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_notifier.dart';
import 'package:ctr/presentation/myreceipts/search_param.dart';
import 'package:ctr/presentation/myreceipts/search_ui.dart';
import 'package:ctr/presentation/signin/signin_notifier.dart';
import 'package:ctr/presentation/signin_fns/signin_fns_notifier.dart';
import 'package:ctr/presentation/signup/signup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final myReceiptsNotifier = ChangeNotifierProvider<MyReceiptsNotifier>((_) {
  return MyReceiptsNotifier();
});

final myReceiptsStreamProvider = StreamProvider.autoDispose
    .family<List<MyItemUI>, BuildContext>((ref, context) {
  final notifier = ref.watch(myReceiptsNotifier);
  return notifier.receipts(context);
});

final searchStreamProvider = StreamProvider.autoDispose
    .family<List<SearchUI>, SearchParam>((ref, param) {
  final notifier = ref.watch(myReceiptsNotifier);
  return notifier.search(param.context, param.filter);
});

final userInteractor = Provider<UserInteractor>((_) => UserInteractor());

final signInNotifier = ChangeNotifierProvider<SignInNotifier>((_) {
  return SignInNotifier();
});

final signUpNotifier = ChangeNotifierProvider<SignUpNotifier>((_) {
  return SignUpNotifier();
});

final drawerNotifier =
    ChangeNotifierProvider.family<DrawerNotifier, BuildContext>((_, context) {
  return DrawerNotifier(context);
});

final signInFnsNotifier = ChangeNotifierProvider<SignInFnsNotifier>((_) {
  return SignInFnsNotifier();
});

final fromFileNotifier = ChangeNotifierProvider<FromFileNotifier>((_) {
  return FromFileNotifier();
});

final cameraNotifier = ChangeNotifierProvider<CameraNotifier>((_) {
  return CameraNotifier();
});

final drawerDropDownNotifier =
    ChangeNotifierProvider<DrawerDropDownNotifier>((_) {
  return DrawerDropDownNotifier();
});

final dropDownStreamProvider = StreamProvider.autoDispose
    .family<List<BudgetUI>, BuildContext>((ref, context) {
  final notifier = ref.watch(drawerDropDownNotifier);
  return notifier.getBudgets(context);
});

final receiptDetailsNotifier =
    ChangeNotifierProvider.family<ReceiptDetailsNotifier, ReceiptDetailsParam>(
        (_, param) {
  return ReceiptDetailsNotifier(param.context, param.receipt);
});

final receiptDetailsUIStreamProvider = StreamProvider.autoDispose
    .family<MyReceiptUI, ReceiptDetailsParam>((ref, param) {
  final notifier = ref.watch(receiptDetailsNotifier(param));
  return notifier.getUI(param.context);
});

final receiptDetailsIrkktFutureProvider =
    FutureProvider.autoDispose.family<int, ReceiptDetailsParam>((ref, param) {
  final notifier = ref.watch(receiptDetailsNotifier(param));
  return notifier.getIrkktReceipt(param.context);
});

final budgetsNotifier = ChangeNotifierProvider<BudgetsNotifier>((_) {
  return BudgetsNotifier();
});

final budgetsStreamProvider = StreamProvider.autoDispose
    .family<List<BudgetUI>, BuildContext>((ref, context) {
  final notifier = ref.watch(drawerDropDownNotifier);
  return notifier.getBudgets(context);
});
