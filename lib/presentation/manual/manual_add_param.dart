import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/receipt.dart';

class ManualAddParam extends Equatable {
  ManualAddParam(this.context, this.item);

  final BuildContext context;
  final ReceiptItem? item;

  @override
  List<Object?> get props => [context, item];
}
