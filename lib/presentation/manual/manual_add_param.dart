import 'package:ctr/domain/entity/receipt.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ManualAddParam extends Equatable {
  ManualAddParam(this.context, this.item);

  final BuildContext context;
  final ReceiptItem? item;

  @override
  List<Object?> get props => [context, item];
}
