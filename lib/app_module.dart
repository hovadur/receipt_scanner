import 'package:ctr/domain/data/api/irkkt_api.dart';
import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/presentation/budgets/budget_add_notifier.dart';
import 'package:ctr/presentation/budgets/budget_add_param.dart';
import 'package:ctr/presentation/budgets/budgets_notifier.dart';
import 'package:ctr/presentation/budgets/budgets_ui.dart';
import 'package:ctr/presentation/camera/camera_notifier.dart';
import 'package:ctr/presentation/details/receipt_details_notifier.dart';
import 'package:ctr/presentation/details/receipt_details_param.dart';
import 'package:ctr/presentation/drawer/drawer_dropdown_notifier.dart';
import 'package:ctr/presentation/drawer/drawer_notifier.dart';
import 'package:ctr/presentation/fromFile/from_file_notifier.dart';
import 'package:ctr/presentation/manual/manual_add_notifier.dart';
import 'package:ctr/presentation/manual/manual_add_param.dart';
import 'package:ctr/presentation/manual/manual_notifier.dart';
import 'package:ctr/presentation/manual/manual_param.dart';
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

import 'domain/data/repo/irkkt_repo.dart';
import 'domain/data/repo/settings_repo.dart';

final settingsRepo = Provider<SettingsRepo>((_) => throw UnimplementedError());

final irkktRepo = Provider<IrkktRepo>((ref) {
  final s = ref.watch(settingsRepo);
  return IrkktRepo(IrkktApi(), s);
});

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

final signInNotifier = ChangeNotifierProvider<SignInNotifier>((ref) {
  final s = ref.watch(userInteractor);
  return SignInNotifier(s);
});

final signUpNotifier = ChangeNotifierProvider<SignUpNotifier>((ref) {
  final s = ref.watch(userInteractor);
  return SignUpNotifier(s);
});

final drawerNotifier =
    ChangeNotifierProvider.family<DrawerNotifier, BuildContext>((_, context) {
  return DrawerNotifier(context);
});

final signInFnsNotifier = ChangeNotifierProvider<SignInFnsNotifier>((ref) {
  final s = ref.watch(irkktRepo);
  return SignInFnsNotifier(s);
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
        (ref, param) {
  final s = ref.watch(irkktRepo);
  return ReceiptDetailsNotifier(param.context, param.receipt, s);
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

final manualNotifier =
    ChangeNotifierProvider.family<ManualNotifier, ManualParam>((_, param) {
  return ManualNotifier(param.context, param.receipt);
});

final manualAddNotifier =
    ChangeNotifierProvider.family<ManualAddNotifier, ManualAddParam>(
        (_, param) {
  return ManualAddNotifier(param.context, param.item);
});

final budgetAddNotifier =
    ChangeNotifierProvider.family<BudgetAddNotifier, BudgetAddParam>(
        (_, param) {
  return BudgetAddNotifier(param.context, param.budget);
});
