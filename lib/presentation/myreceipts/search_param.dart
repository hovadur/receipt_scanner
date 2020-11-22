import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SearchParam extends Equatable {
  SearchParam(this.context, this.filter);

  final BuildContext context;
  final String filter;

  @override
  List<Object?> get props => [context, filter];
}
