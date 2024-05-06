import '/flutter_flow/flutter_flow_util.dart';
import 'competitions_widget.dart' show CompetitionsWidget;
import 'package:flutter/material.dart';

class CompetitionsModel extends FlutterFlowModel<CompetitionsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
