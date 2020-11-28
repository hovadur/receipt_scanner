import 'package:ctr/domain/entity/receipt.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ManualParam extends Equatable {
  ManualParam(this.context, this.receipt);

  final BuildContext context;
  final Receipt? receipt;

  @override
  List<Object?> get props => [context, receipt];
}
