import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/receipt.dart';

class ManualParam extends Equatable {
  ManualParam(this.context, this.receipt);

  final BuildContext context;
  final Receipt? receipt;

  @override
  List<Object?> get props => [context, receipt];
}
