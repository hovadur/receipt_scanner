import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/presentation/drawer/drawer_notifier.dart';
import 'package:ctr/presentation/myreceipts/my_item_ui.dart';
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
