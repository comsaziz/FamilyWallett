import '/flutter_flow/flutter_flow_util.dart';
import 'manage_wallets_widget.dart' show ManageWalletsWidget;
import 'package:flutter/material.dart';

class ManageWalletsModel extends FlutterFlowModel<ManageWalletsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
