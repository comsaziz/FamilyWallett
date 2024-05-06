import '/flutter_flow/flutter_flow_util.dart';
import 'follower_dashboard_widget.dart' show FollowerDashboardWidget;
import 'package:flutter/material.dart';

class FollowerDashboardModel extends FlutterFlowModel<FollowerDashboardWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
